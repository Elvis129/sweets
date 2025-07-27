import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/game_state_provider.dart';
import '../../core/theme/app_theme.dart';

class ShopDialog extends StatelessWidget {
  const ShopDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
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
              children: [
                // Title and close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 30),
                    const Text(
                      'SHOP',
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
                const SizedBox(height: 16),

                // Credits display
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Credits: ${gameState.credits.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppTheme.textWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),

                // Backgrounds grid
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _BackgroundItem(
                        id: 'candy_land',
                        name: 'Candy Land',
                        cost: 0,
                        isUnlocked: true,
                        isSelected:
                            gameState.selectedBackground == 'candy_land',
                        onSelect: () =>
                            gameState.selectBackground('candy_land'),
                      ),
                      _BackgroundItem(
                        id: 'enchanted_candy_forest',
                        name: 'Enchanted Forest',
                        cost: 500,
                        isUnlocked: gameState.unlockedBackgrounds
                            .contains('enchanted_candy_forest'),
                        isSelected: gameState.selectedBackground ==
                            'enchanted_candy_forest',
                        onSelect: () => gameState
                            .selectBackground('enchanted_candy_forest'),
                        onBuy: () => gameState.unlockBackground(
                            'enchanted_candy_forest', 500),
                      ),
                      _BackgroundItem(
                        id: 'dark_candy_dungeon',
                        name: 'Candy Dungeon',
                        cost: 800,
                        isUnlocked: gameState.unlockedBackgrounds
                            .contains('dark_candy_dungeon'),
                        isSelected: gameState.selectedBackground ==
                            'dark_candy_dungeon',
                        onSelect: () =>
                            gameState.selectBackground('dark_candy_dungeon'),
                        onBuy: () => gameState.unlockBackground(
                            'dark_candy_dungeon', 800),
                      ),
                      _BackgroundItem(
                        id: 'cotton_candy_sky_islands',
                        name: 'Sky Islands',
                        cost: 1000,
                        isUnlocked: gameState.unlockedBackgrounds
                            .contains('cotton_candy_sky_islands'),
                        isSelected: gameState.selectedBackground ==
                            'cotton_candy_sky_islands',
                        onSelect: () => gameState
                            .selectBackground('cotton_candy_sky_islands'),
                        onBuy: () => gameState.unlockBackground(
                            'cotton_candy_sky_islands', 1000),
                      ),
                      _BackgroundItem(
                        id: 'chocolate_river_valley',
                        name: 'Chocolate Valley',
                        cost: 1200,
                        isUnlocked: gameState.unlockedBackgrounds
                            .contains('chocolate_river_valley'),
                        isSelected: gameState.selectedBackground ==
                            'chocolate_river_valley',
                        onSelect: () => gameState
                            .selectBackground('chocolate_river_valley'),
                        onBuy: () => gameState.unlockBackground(
                            'chocolate_river_valley', 1200),
                      ),
                      _BackgroundItem(
                        id: 'caramel_mountains',
                        name: 'Caramel Mountains',
                        cost: 1500,
                        isUnlocked: gameState.unlockedBackgrounds
                            .contains('caramel_mountains'),
                        isSelected:
                            gameState.selectedBackground == 'caramel_mountains',
                        onSelect: () =>
                            gameState.selectBackground('caramel_mountains'),
                        onBuy: () => gameState.unlockBackground(
                            'caramel_mountains', 1500),
                      ),
                      _BackgroundItem(
                        id: 'gingerbread_village',
                        name: 'Gingerbread Village',
                        cost: 2000,
                        isUnlocked: gameState.unlockedBackgrounds
                            .contains('gingerbread_village'),
                        isSelected: gameState.selectedBackground ==
                            'gingerbread_village',
                        onSelect: () =>
                            gameState.selectBackground('gingerbread_village'),
                        onBuy: () => gameState.unlockBackground(
                            'gingerbread_village', 2000),
                      ),
                      _BackgroundItem(
                        id: 'jelly_ocean_coast',
                        name: 'Jelly Coast',
                        cost: 2500,
                        isUnlocked: gameState.unlockedBackgrounds
                            .contains('jelly_ocean_coast'),
                        isSelected:
                            gameState.selectedBackground == 'jelly_ocean_coast',
                        onSelect: () =>
                            gameState.selectBackground('jelly_ocean_coast'),
                        onBuy: () => gameState.unlockBackground(
                            'jelly_ocean_coast', 2500),
                      ),
                      _BackgroundItem(
                        id: 'steampunk_candy_world',
                        name: 'Sugarpunk World',
                        cost: 3000,
                        isUnlocked: gameState.unlockedBackgrounds
                            .contains('steampunk_candy_world'),
                        isSelected: gameState.selectedBackground ==
                            'steampunk_candy_world',
                        onSelect: () =>
                            gameState.selectBackground('steampunk_candy_world'),
                        onBuy: () => gameState.unlockBackground(
                            'steampunk_candy_world', 3000),
                      ),
                      _BackgroundItem(
                        id: 'futuristic_neon_candy_city',
                        name: 'Neon City',
                        cost: 5000,
                        isUnlocked: gameState.unlockedBackgrounds
                            .contains('futuristic_neon_candy_city'),
                        isSelected: gameState.selectedBackground ==
                            'futuristic_neon_candy_city',
                        onSelect: () => gameState
                            .selectBackground('futuristic_neon_candy_city'),
                        onBuy: () => gameState.unlockBackground(
                            'futuristic_neon_candy_city', 5000),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BackgroundItem extends StatelessWidget {
  final String id;
  final String name;
  final double cost;
  final bool isUnlocked;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback? onBuy;

  const _BackgroundItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.isUnlocked,
    required this.isSelected,
    required this.onSelect,
    this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: AppTheme.primaryPink, width: 3)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/backgrounds/$id.png',
            fit: BoxFit.cover,
          ),

          // Overlay for locked backgrounds
          if (!isUnlocked)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppTheme.textWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: onBuy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonOrange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        'Buy: ${cost.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Overlay for unlocked backgrounds
          if (isUnlocked)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSelect,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: AppTheme.textWhite,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
