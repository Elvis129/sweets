import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<StorageService> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    return StorageService();
  }

  // Credits management
  Future<void> setCredits(double credits) async {
    await _prefs.setDouble('credits', credits);
  }

  double getCredits() {
    return _prefs.getDouble('credits') ?? 1000.0; // Default starting credits
  }

  // Bet management
  Future<void> setCurrentBet(int bet) async {
    await _prefs.setInt('current_bet', bet);
  }

  int getCurrentBet() {
    return _prefs.getInt('current_bet') ?? 10; // Default bet
  }

  // Background management
  Future<void> setSelectedBackground(String backgroundId) async {
    await _prefs.setString('selected_background', backgroundId);
  }

  String getSelectedBackground() {
    return _prefs.getString('selected_background') ??
        'candy_land'; // Default background
  }

  Future<void> unlockBackground(String backgroundId) async {
    final unlockedBackgrounds = getUnlockedBackgrounds();
    if (!unlockedBackgrounds.contains(backgroundId)) {
      unlockedBackgrounds.add(backgroundId);
      await _prefs.setStringList('unlocked_backgrounds', unlockedBackgrounds);
    }
  }

  List<String> getUnlockedBackgrounds() {
    return _prefs.getStringList('unlocked_backgrounds') ?? ['candy_land'];
  }

  // Settings management
  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool('sound_enabled', enabled);
  }

  bool getSoundEnabled() {
    return _prefs.getBool('sound_enabled') ?? true;
  }

  Future<void> setMusicEnabled(bool enabled) async {
    await _prefs.setBool('music_enabled', enabled);
  }

  bool getMusicEnabled() {
    return _prefs.getBool('music_enabled') ?? true;
  }

  // Reset game
  Future<void> resetGame() async {
    await _prefs.setDouble('credits', 1000.0);
    await _prefs.setStringList('unlocked_backgrounds', ['candy_land']);
    await _prefs.setString('selected_background', 'candy_land');
    await _prefs.setInt('current_bet', 10); // Reset bet to default
  }
}
