import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/providers/game_state_provider.dart';
import 'core/services/audio_service.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/game/game_screen.dart';
import 'features/home/home_screen.dart';
import 'features/loading/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize services
  final storageService = await StorageService.initialize();
  final audioService = await AudioService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GameStateProvider(
            storageService: storageService,
            audioService: audioService,
          ),
        ),
      ],
      child: const SweetBillionsApp(),
    ),
  );
}

class SweetBillionsApp extends StatelessWidget {
  const SweetBillionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sweet Billions',
      theme: AppTheme.lightTheme,
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => const LoadingScreen(),
        '/home': (context) => const HomeScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}
