import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/game_state_provider.dart';

class _BetButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final bool isEnabled;

  const _BetButton({
    required this.onTap,
    required this.child,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.3,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class BetSettingsDialog extends StatelessWidget {
  const BetSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        final currentIndex =
            GameStateProvider.availableBets.indexOf(gameState.currentBet);
        final canDecrease = currentIndex > 0;
        final canIncrease =
            currentIndex < GameStateProvider.availableBets.length - 1 &&
                GameStateProvider.availableBets[currentIndex + 1] <=
                    gameState.credits;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.cyan,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title and close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 30),
                    const Text(
                      'BET SETTINGS',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.cyan,
                        size: 30,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Total bet display
                const Text(
                  'TOTAL BET',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Bet controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Decrease button
                    _BetButton(
                      onTap: () {
                        if (currentIndex > 0) {
                          gameState.setBet(GameStateProvider
                              .availableBets[currentIndex - 1]);
                        }
                      },
                      isEnabled: canDecrease,
                      child: const Icon(Icons.remove,
                          color: Colors.white, size: 40),
                    ),

                    // Current bet display
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        gameState.currentBet.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Increase button
                    _BetButton(
                      onTap: () {
                        if (currentIndex <
                            GameStateProvider.availableBets.length - 1) {
                          final nextBet =
                              GameStateProvider.availableBets[currentIndex + 1];
                          if (nextBet <= gameState.credits) {
                            gameState.setBet(nextBet);
                          }
                        }
                      },
                      isEnabled: canIncrease,
                      child:
                          const Icon(Icons.add, color: Colors.white, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
