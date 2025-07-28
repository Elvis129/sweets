import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/providers/game_state_provider.dart';
import 'core/services/app_lifecycle_service.dart';
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

  // Initialize app lifecycle service
  final appLifecycleService = AppLifecycleService(audioService);

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
      child: SweetBillionsApp(appLifecycleService: appLifecycleService),
    ),
  );
}

class SweetBillionsApp extends StatefulWidget {
  final AppLifecycleService appLifecycleService;

  const SweetBillionsApp({super.key, required this.appLifecycleService});

  @override
  State<SweetBillionsApp> createState() => _SweetBillionsAppState();
}

class _SweetBillionsAppState extends State<SweetBillionsApp> {
  @override
  void dispose() {
    widget.appLifecycleService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create global navigator key for toast access
    final navigatorKey = GlobalKey<NavigatorState>();

    // Set global keys for services
    AudioService.navigatorKey = navigatorKey;
    GameStateProvider.navigatorKey = navigatorKey;

    return MaterialApp(
      title: 'Sweet Billions',
      theme: AppTheme.lightTheme,
      navigatorKey: navigatorKey,
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => const LoadingScreen(),
        '/home': (context) => const HomeScreen(),
        '/game': (context) => const GameScreen(),
      },
    );
  }
}
