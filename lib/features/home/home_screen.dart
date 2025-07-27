import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
                  Container(),
                  // Game title
                  Text(
                    'Sweet Billions',
                    style: GoogleFonts.bubblegumSans(
                      color: AppTheme.textWhite,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const Shadow(
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
                          child: Text(
                            'PLAY',
                            style: GoogleFonts.bubblegumSans(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                          child: Text(
                            'SHOP',
                            style: GoogleFonts.bubblegumSans(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: IconButton(
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
                      ),
                    ],
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
