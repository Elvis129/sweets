import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static late AudioPlayer _musicPlayer;
  final Map<String, AudioPlayer> _soundPlayers = {};
  bool _isMusicReady = false;
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  static Future<AudioService> initialize() async {
    _musicPlayer = AudioPlayer()
      ..setReleaseMode(ReleaseMode.loop)
      ..setPlayerMode(PlayerMode.lowLatency);
    return AudioService();
  }

  Future<AudioPlayer> _getOrCreateSoundPlayer(String soundName) async {
    // If we already have a player for this sound, dispose it first
    if (_soundPlayers.containsKey(soundName)) {
      try {
        final existingPlayer = _soundPlayers[soundName]!;
        await existingPlayer.dispose();
      } catch (e) {
        print('Error disposing existing player for $soundName: $e');
      }
    }

    // Create a new player for this sound
    final player = AudioPlayer()
      ..setReleaseMode(ReleaseMode.release)
      ..setPlayerMode(PlayerMode.lowLatency);
    _soundPlayers[soundName] = player;
    return player;
  }

  // Music controls
  Future<void> playBackgroundMusic() async {
    if (!_musicEnabled) return;

    try {
      if (!_isMusicReady) {
        await _musicPlayer.setSource(AssetSource('music/candy_wonderland.mp3'));
        _isMusicReady = true;
      }
      await _musicPlayer.resume();
    } catch (e) {
      print('Error playing background music: $e');
      _isMusicReady = false;
      // Try to recreate music player on error
      try {
        await _musicPlayer.dispose();
        _musicPlayer = AudioPlayer()
          ..setReleaseMode(ReleaseMode.loop)
          ..setPlayerMode(PlayerMode.lowLatency);
      } catch (e2) {
        print('Error recreating music player: $e2');
      }
    }
  }

  Future<void> stopBackgroundMusic() async {
    try {
      if (_musicPlayer.state == PlayerState.playing) {
        await _musicPlayer.pause();
      }
    } catch (e) {
      print('Error stopping background music: $e');
    }
  }

  Future<void> setMusicVolume(double volume) async {
    try {
      await _musicPlayer.setVolume(volume);
    } catch (e) {
      print('Error setting music volume: $e');
    }
  }

  // Sound effects
  Future<void> playSound(String soundName) async {
    if (!_soundEnabled) return;

    try {
      final player = await _getOrCreateSoundPlayer(soundName);

      // Set source and play
      await player.setSource(AssetSource('sounds/$soundName.mp3'));
      await player.resume();

      // Set up completion listener to dispose the player
      player.onPlayerComplete.listen((_) async {
        try {
          await player.dispose();
          _soundPlayers.remove(soundName);
        } catch (e) {
          print('Error disposing player after completion: $e');
        }
      });
    } catch (e) {
      print('Error playing sound $soundName: $e');
      // Remove the failed player
      _soundPlayers.remove(soundName);
    }
  }

  Future<void> setSoundVolume(double volume) async {
    for (final player in _soundPlayers.values) {
      try {
        await player.setVolume(volume);
      } catch (e) {
        print('Error setting sound volume: $e');
      }
    }
  }

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
    if (!enabled) {
      // Stop and dispose all sound players
      for (final player in _soundPlayers.values) {
        try {
          player.dispose();
        } catch (e) {
          print('Error disposing sound player: $e');
        }
      }
      _soundPlayers.clear();
    }
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    } else {
      playBackgroundMusic();
    }
  }

  // Cleanup
  Future<void> dispose() async {
    try {
      await _musicPlayer.dispose();
      for (final player in _soundPlayers.values) {
        await player.dispose();
      }
      _soundPlayers.clear();
      _isMusicReady = false;
    } catch (e) {
      print('Error disposing audio service: $e');
    }
  }

  // Sound names
  static const String clickSound = 'click';
  static const String spinStartSound = 'spin_start1';
  static const String winSound = 'win';
  static const String loseSound = 'lose';
  static const String creditsGainedSound = 'credits_gained';
}
