import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'audio_service.dart';

class AppLifecycleService extends WidgetsBindingObserver {
  final AudioService _audioService;

  AppLifecycleService(this._audioService) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      print('AppLifecycleService: App state changed to $state');
    }

    switch (state) {
      case AppLifecycleState.paused:
        if (kDebugMode) {
          print('AppLifecycleService: App paused - pausing music');
        }
        _audioService.onAppPaused();
        break;
      case AppLifecycleState.resumed:
        if (kDebugMode) {
          print('AppLifecycleService: App resumed - resuming music');
        }
        _audioService.onAppResumed();
        break;
      case AppLifecycleState.detached:
        if (kDebugMode) {
          print('AppLifecycleService: App detached - pausing music');
        }
        _audioService.onAppPaused();
        break;
      case AppLifecycleState.hidden:
        if (kDebugMode) {
          print('AppLifecycleService: App hidden - pausing music');
        }
        _audioService.onAppPaused();
        break;
      case AppLifecycleState.inactive:
        if (kDebugMode) {
          print('AppLifecycleService: App inactive - pausing music');
        }
        _audioService.onAppPaused();
        break;
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
