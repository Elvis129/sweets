import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers/game_state_provider.dart';
import '../../core/theme/app_theme.dart';
import '../settings/settings_dialog.dart';
import '../shop/shop_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/backgrounds/${gameState.selectedBackground}.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top section with credits
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Credits: ${gameState.credits.toStringAsFixed(1)}',
                            style: const TextStyle(
                              color: AppTheme.textWhite,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Game title
                  const Text(
                    'Sweet Billions',
                    style: TextStyle(
                      color: AppTheme.textWhite,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),

                  // Bottom section with buttons
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/game');
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 60),
                          ),
                          child: const Text('PLAY'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const ShopDialog(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.buttonOrange,
                            minimumSize: const Size(200, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'SHOP',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const SettingsDialog(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
