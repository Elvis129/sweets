import 'package:flutter/material.dart';

import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../services/toast_service.dart';

class GameStateProvider extends ChangeNotifier {
  final StorageService storageService;
  final AudioService audioService;

  // Global key for accessing context
  static GlobalKey<NavigatorState>? navigatorKey;

  double _credits = 1000;
  bool _isSpinning = false;
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  String _selectedBackground = 'candy_land';
  List<String> _unlockedBackgrounds = ['candy_land'];
  double _buttonScale = 1.0;
  int _currentBet = 10;
  static const List<int> availableBets = [
    1,
    2,
    5,
    10,
    20,
    50,
    100,
    200,
    500,
    1000
  ];
  String _gameStatusText = 'PLACE YOUR BETS!';

  GameStateProvider({
    required this.storageService,
    required this.audioService,
  }) {
    _loadSettings();
  }

  // Load all settings from storage
  Future<void> _loadSettings() async {
    _credits = storageService.getCredits();
    _soundEnabled = storageService.getSoundEnabled();
    _musicEnabled = storageService.getMusicEnabled();
    _selectedBackground = storageService.getSelectedBackground();
    _unlockedBackgrounds = storageService.getUnlockedBackgrounds();
    _currentBet = storageService.getCurrentBet();

    // Apply loaded settings
    audioService.setSoundEnabled(_soundEnabled);
    audioService.setMusicEnabled(_musicEnabled);
    if (_musicEnabled) {
      audioService.playBackgroundMusic();
    }

    notifyListeners();
  }

  double get credits => _credits;
  bool get isSpinning => _isSpinning;
  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  String get selectedBackground => _selectedBackground;
  double get buttonScale => _buttonScale;
  List<String> get unlockedBackgrounds =>
      List.unmodifiable(_unlockedBackgrounds);
  int get currentBet => _currentBet;
  String get gameStatusText => _gameStatusText;

  void setSpinning(bool value) {
    _isSpinning = value;
    if (value) {
      setGameStatusText('SPINNING...');
    } else {
      setGameStatusText('PLACE YOUR BETS!');
    }
    notifyListeners();
  }

  void setButtonScale(double scale) {
    _buttonScale = scale;
    notifyListeners();
  }

  Future<void> addCredits(double amount) async {
    _credits += amount;
    await storageService.setCredits(_credits);
    if (_soundEnabled && amount > 0) {
      try {
        await audioService.playSound(AudioService.creditsGainedSound);
      } catch (e) {
        _showErrorToast('Error playing credits gained sound: $e');
      }
    }
    notifyListeners();
  }

  Future<void> deductCredits(double amount) async {
    if (_credits >= amount) {
      _credits -= amount;
      await storageService.setCredits(_credits);
      notifyListeners();
    }
  }

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    audioService.setSoundEnabled(enabled);
    storageService.setSoundEnabled(enabled);
    notifyListeners();
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    audioService.setMusicEnabled(enabled);
    storageService.setMusicEnabled(enabled);
    notifyListeners();
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    audioService.setSoundEnabled(_soundEnabled);
    storageService.setSoundEnabled(_soundEnabled);
    notifyListeners();
  }

  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    audioService.setMusicEnabled(_musicEnabled);
    storageService.setMusicEnabled(_musicEnabled);
    notifyListeners();
  }

  void setSelectedBackground(String background) {
    _selectedBackground = background;
    storageService.setSelectedBackground(background);
    notifyListeners();
  }

  void setBet(int bet) {
    if (bet <= _credits && availableBets.contains(bet)) {
      _currentBet = bet;
      storageService.setCurrentBet(bet);
      notifyListeners();
    }
  }

  // Updated method for deducting bet
  Future<void> deductBet() async {
    if (_credits >= _currentBet) {
      _credits -= _currentBet;
      notifyListeners();
    }
  }

  // Updated method for adding winnings with bet consideration
  Future<void> addWinnings(double multiplier) async {
    final winAmount = _currentBet * multiplier;
    _credits += winAmount;
    setGameStatusText('YOU WON: ${multiplier.toStringAsFixed(0)}x!');
    notifyListeners();
  }

  void setGameStatusText(String text) {
    _gameStatusText = text;
    notifyListeners();
  }

  // Background management
  Future<void> selectBackground(String backgroundId) async {
    if (_unlockedBackgrounds.contains(backgroundId)) {
      _selectedBackground = backgroundId;
      await storageService.setSelectedBackground(backgroundId);
      notifyListeners();
    }
  }

  Future<void> unlockBackground(String backgroundId, double cost) async {
    if (_credits >= cost && !_unlockedBackgrounds.contains(backgroundId)) {
      await deductCredits(cost);
      _unlockedBackgrounds.add(backgroundId);
      await storageService.unlockBackground(backgroundId);
      // Automatically select new background after purchase
      _selectedBackground = backgroundId;
      await storageService.setSelectedBackground(backgroundId);
      notifyListeners();
    }
  }

  // Reset game
  Future<void> resetGame() async {
    // Reset credits and bet
    _credits = 1000;
    _currentBet = 10;

    // Reset backgrounds
    _selectedBackground = 'candy_land';
    _unlockedBackgrounds = ['candy_land'];

    // Reset settings
    _soundEnabled = true;
    _musicEnabled = true;
    audioService.setSoundEnabled(true);
    audioService.setMusicEnabled(true);
    await audioService.playBackgroundMusic();

    // Save reset state
    await storageService.resetGame();
    await storageService.setSoundEnabled(true);
    await storageService.setMusicEnabled(true);

    setGameStatusText('PLACE YOUR BETS!');
    notifyListeners();
  }

  @override
  void dispose() {
    audioService.dispose();
    super.dispose();
  }

  // Helper method to show error toast
  void _showErrorToast(String message) {
    if (navigatorKey?.currentContext != null) {
      ToastService.showError(navigatorKey!.currentContext!, message);
    }
  }
}
