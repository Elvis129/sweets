import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'toast_service.dart';

class AudioService {
  static late AudioPlayer _musicPlayer;
  final Map<String, AudioPlayer> _soundPlayers = {};
  bool _isMusicReady = false;
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _wasMusicPlaying =
      false; // Track if music was playing before app was paused

  // Global key for accessing context
  static GlobalKey<NavigatorState>? navigatorKey;

  static Future<AudioService> initialize() async {
    _musicPlayer = AudioPlayer();
    await _musicPlayer.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.none,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: const {AVAudioSessionOptions.mixWithOthers},
      ),
    ));
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    return AudioService();
  }

  Future<AudioPlayer> _getOrCreateSoundPlayer(String soundName) async {
    // If we already have a player for this sound, dispose it first
    if (_soundPlayers.containsKey(soundName)) {
      try {
        final existingPlayer = _soundPlayers[soundName]!;
        await existingPlayer.dispose();
      } catch (e) {
        _showErrorToast('Error disposing existing player for $soundName: $e');
      }
    }

    // Create a new player for this sound
    final player = AudioPlayer();
    await player.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        isSpeakerphoneOn: false,
        stayAwake: false,
        contentType: AndroidContentType.sonification,
        usageType: AndroidUsageType.assistanceSonification,
        audioFocus: AndroidAudioFocus.none,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: const {AVAudioSessionOptions.mixWithOthers},
      ),
    ));
    await player.setReleaseMode(ReleaseMode.release);
    await player.setPlayerMode(PlayerMode.lowLatency);
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
      _showErrorToast('Error playing background music: $e');
      _isMusicReady = false;
      // Try to recreate music player on error
      try {
        await _musicPlayer.dispose();
        _musicPlayer = AudioPlayer()
          ..setReleaseMode(ReleaseMode.loop)
          ..setPlayerMode(PlayerMode.lowLatency);
      } catch (e2) {
        _showErrorToast('Error recreating music player: $e2');
      }
    }
  }

  Future<void> stopBackgroundMusic() async {
    try {
      if (_musicPlayer.state == PlayerState.playing) {
        await _musicPlayer.pause();
      }
    } catch (e) {
      _showErrorToast('Error stopping background music: $e');
    }
  }

  // App lifecycle methods
  Future<void> onAppPaused() async {
    try {
      if (kDebugMode) {
        print(
            'AudioService: onAppPaused - music enabled: $_musicEnabled, player state: ${_musicPlayer.state}');
      }

      if (_musicEnabled && _musicPlayer.state == PlayerState.playing) {
        _wasMusicPlaying = true;
        if (kDebugMode) {
          print(
              'AudioService: Music was playing, setting _wasMusicPlaying to true');
        }
        await stopBackgroundMusic();
      } else {
        _wasMusicPlaying = false;
        if (kDebugMode) {
          print(
              'AudioService: Music was not playing, setting _wasMusicPlaying to false');
        }
      }
    } catch (e) {
      _showErrorToast('Error in onAppPaused: $e');
      _wasMusicPlaying = false;
    }
  }

  Future<void> onAppResumed() async {
    try {
      if (kDebugMode) {
        print(
            'AudioService: onAppResumed - music enabled: $_musicEnabled, was playing: $_wasMusicPlaying');
      }

      // Якщо музика увімкнена в налаштуваннях — просто відновлюємо
      if (_musicEnabled) {
        // Маленька затримка на відновлення контексту
        await Future.delayed(const Duration(milliseconds: 300));

        if (kDebugMode) {
          print('AudioService: Playing background music on resume');
        }
        await playBackgroundMusic();
      }
    } catch (e) {
      _showErrorToast('Error in onAppResumed: $e');
    }
  }

  // Test methods for debugging
  bool get wasMusicPlaying => _wasMusicPlaying;
  bool get isMusicEnabled => _musicEnabled;
  PlayerState get musicPlayerState => _musicPlayer.state;

  Future<void> setMusicVolume(double volume) async {
    try {
      await _musicPlayer.setVolume(volume);
    } catch (e) {
      _showErrorToast('Error setting music volume: $e');
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
          _showErrorToast('Error disposing player after completion: $e');
        }
      });
    } catch (e) {
      _showErrorToast('Error playing sound $soundName: $e');
      // Remove the failed player
      _soundPlayers.remove(soundName);
    }
  }

  Future<void> setSoundVolume(double volume) async {
    for (final player in _soundPlayers.values) {
      try {
        await player.setVolume(volume);
      } catch (e) {
        _showErrorToast('Error setting sound volume: $e');
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
          _showErrorToast('Error disposing sound player: $e');
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
      _showErrorToast('Error disposing audio service: $e');
    }
  }

  // Sound names
  static const String clickSound = 'click';
  static const String spinStartSound = 'spin_start1';
  static const String winSound = 'win';
  static const String loseSound = 'lose';
  static const String creditsGainedSound = 'credits_gained';

  // Helper method to show error toast
  void _showErrorToast(String message) {
    if (navigatorKey?.currentContext != null) {
      ToastService.showError(navigatorKey!.currentContext!, message);
    }
  }
}
