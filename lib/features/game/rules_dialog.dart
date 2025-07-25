import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class RulesDialog extends StatelessWidget {
  const RulesDialog({super.key});

  Widget _buildSymbolRule({
    required String symbol,
    required List<String> multipliers,
    double size = 50, // Зменшили розмір з 60 до 50
  }) {
    return SizedBox(
      width: 120, // Зменшили ширину з 140 до 120
      child: Column(
        children: [
          Image.asset(
            'assets/images/symbols/$symbol.png',
            width: size,
            height: size,
          ),
          const SizedBox(height: 4), // Зменшили відступ з 8 до 4
          Column(
            children: [
              Text(
                '7: x${multipliers[0]}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12, // Зменшили шрифт з 14 до 12
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '8-10: x${multipliers[1]}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '11+: x${multipliers[2]}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300, // Фіксована ширина діалогу
        padding: const EdgeInsets.all(16), // Зменшили padding з 24 до 16
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.cyan,
            width: 2,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  const Text(
                    'GAME RULES',
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
              const SizedBox(height: 16), // Зменшили відступ з 24 до 16

              // Symbols grid
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSymbolRule(
                    symbol: 'candy',
                    multipliers: ['0.5', '1.2', '1.4'],
                  ),
                  const SizedBox(width: 12), // Зменшили відступ з 20 до 12
                  _buildSymbolRule(
                    symbol: 'orange',
                    multipliers: ['0.7', '1.3', '1.4'],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSymbolRule(
                    symbol: 'cherry',
                    multipliers: ['0.7', '1.3', '1.5'],
                  ),
                  const SizedBox(width: 12),
                  _buildSymbolRule(
                    symbol: 'grapes',
                    multipliers: ['0.7', '1.3', '1.5'],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSymbolRule(
                    symbol: 'watermelon',
                    multipliers: ['1.0', '1.4', '1.8'],
                  ),
                  const SizedBox(width: 12),
                  _buildSymbolRule(
                    symbol: 'strawberry',
                    multipliers: ['1.0', '1.4', '1.8'],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSymbolRule(
                    symbol: 'gummy',
                    multipliers: ['1.2', '1.6', '2.2'],
                  ),
                  const SizedBox(width: 12),
                  _buildSymbolRule(
                    symbol: 'jelly',
                    multipliers: ['1.2', '1.6', '2.2'],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSymbolRule(
                    symbol: 'orange_candy',
                    multipliers: ['1.2', '1.6', '2.2'],
                  ),
                  const SizedBox(width: 12),
                  _buildSymbolRule(
                    symbol: 'lollipop',
                    multipliers: ['1.2', '1.6', '2.2'],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description text
              const Text(
                'Symbols pay anywhere on the screen. The total number of the same symbol on the screen at the end of a spin determines the value of the win.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
