import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/providers/game_state_provider.dart';
import '../settings/settings_dialog.dart';
import 'bet_settings_dialog.dart';
import 'rules_dialog.dart';
import 'sweet_billions_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _animationController;
  bool _isInitialAnimationComplete = false;
  bool _isGameVisible = true;
  late SweetBillionsGame _game; // Add variable

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _game = SweetBillionsGame();
    _game.pauseGame();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward().then((_) {
        if (mounted) {
          setState(() {
            _isInitialAnimationComplete = true;
          });
          _animationController.dispose();
        }
      });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_animationController.isAnimating) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (!didPop && !gameState.isSpinning) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/backgrounds/${gameState.selectedBackground}.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          if (!gameState.isSpinning) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                      ),
                    ),

                    // Title
                    _isInitialAnimationComplete
                        ? _buildStaticTitle()
                        : _buildAnimatedTitle(),

                    // Game area
                    Expanded(
                      child: Visibility(
                          visible: _isGameVisible,
                          maintainState: true,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: GameWidget.controlled(
                              gameFactory: () =>
                                  SweetBillionsGame()..setGameState(gameState),
                            ),
                          )),
                    ),

                    // Bottom panel
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            gameState.gameStatusText,
                            style: GoogleFonts.bubblegumSans(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                const Shadow(
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Spin and bet buttons row
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 100,
                                  height: 60,
                                ),
                                // Spin button
                                GestureDetector(
                                  onTapDown: (_) {
                                    if (!gameState.isSpinning &&
                                        gameState.credits >=
                                            gameState.currentBet) {
                                      gameState.setButtonScale(0.9);
                                      // Play spin start sound
                                      if (gameState.soundEnabled) {
                                        gameState.audioService
                                            .playSound('spin_start1');
                                      }
                                    }
                                  },
                                  onTapUp: (_) {
                                    if (!gameState.isSpinning &&
                                        gameState.credits >=
                                            gameState.currentBet) {
                                      gameState.setButtonScale(1.0);
                                      _game.resumeGame();
                                      SweetBillionsGame.spin();
                                    }
                                  },
                                  onTapCancel: () {
                                    if (!gameState.isSpinning &&
                                        gameState.credits >=
                                            gameState.currentBet) {
                                      gameState.setButtonScale(1.0);
                                    }
                                  },
                                  child: AnimatedScale(
                                    scale: gameState.buttonScale,
                                    duration: const Duration(milliseconds: 100),
                                    child: Opacity(
                                      opacity: (!gameState.isSpinning &&
                                              gameState.credits >=
                                                  gameState.currentBet)
                                          ? 1.0
                                          : 0.3,
                                      child: Image.asset(
                                        'assets/images/icons/button_refresh.png',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                // Bet button
                                GestureDetector(
                                  onTap: () {
                                    if (!gameState.isSpinning) {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const BetSettingsDialog(),
                                      );
                                    }
                                  },
                                  child: Opacity(
                                    opacity: !gameState.isSpinning ? 1.0 : 0.3,
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                        'assets/images/icons/button_credit.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Bottom row with settings, credits/bet, info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const SettingsDialog(),
                                  );
                                },
                              ),
                              Text(
                                'CREDIT: ${gameState.credits.toInt()}',
                                style: GoogleFonts.bubblegumSans(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    const Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '    BET: ${gameState.currentBet}',
                                style: GoogleFonts.bubblegumSans(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    const Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => const RulesDialog(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        setState(() {
          _isGameVisible = false;
        });
        SweetBillionsGame.togglePause();
        break;
      case AppLifecycleState.resumed:
        setState(() {
          _isGameVisible = true;
        });
        SweetBillionsGame.togglePause();
        break;
      default:
        break;
    }
  }

  Widget _buildStaticTitle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          'SWEET BILLIONS',
          style: GoogleFonts.bubblegumSans(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 8
              ..color = Colors.white,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Colors.pink.shade300,
              Colors.purple.shade200,
              Colors.blue.shade200,
            ],
          ).createShader(bounds),
          child: Text(
            'SWEET BILLIONS',
            style: GoogleFonts.bubblegumSans(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedTitle() {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'SWEET BILLIONS',
            style: GoogleFonts.bubblegumSans(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 8
                ..color = Colors.white,
            ),
          ),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Colors.pink.shade300,
                Colors.purple.shade200,
                Colors.blue.shade200,
              ],
            ).createShader(bounds),
            child: Text(
              'SWEET BILLIONS',
              style: GoogleFonts.bubblegumSans(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
