import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/providers/game_state_provider.dart';

class EmptyCell extends PositionComponent {
  EmptyCell({required Vector2 position, required Vector2 size}) {
    this.position = position;
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, paint);
  }
}

class SymbolComponent extends PositionComponent {
  Sprite sprite;
  Vector2 targetPosition;
  bool isAnimating = true;
  bool isVanishing = false;
  double animationProgress = 0.0;
  double vanishScale = 1.0;
  double opacity = 1.0;

  SymbolComponent({
    required this.sprite,
    required Vector2 position,
    required Vector2 size,
    required this.targetPosition,
  }) : super(position: position, size: size);

  void startVanishingAnimation() {
    isVanishing = true;
    animationProgress = 0.0;
  }

  @override
  void update(double dt) {
    if (isVanishing) {
      // Vanishing animation
      animationProgress = (animationProgress + dt * 2.0).clamp(0.0, 1.0);
      vanishScale = 1.0 - animationProgress;
      opacity = 1.0 - animationProgress;
    } else if (isAnimating) {
      // Regular falling animation
      animationProgress = (animationProgress + dt * 5.0).clamp(0.0, 1.0);
      double t = animationProgress * animationProgress;
      position.x = lerpDouble(position.x, targetPosition.x, t)!;
      position.y = lerpDouble(position.y, targetPosition.y, t)!;

      if (animationProgress >= 1.0) {
        isAnimating = false;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (isVanishing) {
      // Save current canvas state
      canvas.save();

      // Set transparency
      canvas.translate(size.x / 2, size.y / 2);
      canvas.scale(vanishScale, vanishScale);
      canvas.translate(-size.x / 2, -size.y / 2);

      sprite.render(
        canvas,
        position: Vector2.zero(),
        size: size,
        overridePaint: Paint()..color = Colors.white.withValues(alpha: opacity),
      );

      // Restore canvas state
      canvas.restore();
    } else {
      sprite.render(
        canvas,
        position: Vector2.zero(),
        size: size,
      );
    }
  }

  void startAnimation() {
    isAnimating = true;
    animationProgress = 0.0;
  }
}

class SweetBillionsGame extends FlameGame with TapDetector {
  // Variable to store the last game status
  String lastGameStatus = 'PLACE YOUR BETS!';

  static SweetBillionsGame? _instance;
  bool _isPaused = false;

  SweetBillionsGame() {
    _instance = this;
  }

  static SweetBillionsGame? get instance => _instance;

  static const int gridRows = 5;
  static const int gridCols = 6;
  static const double spinCost = 10.0;
  late double spacing;

  late GameStateProvider gameState;
  late List<List<SymbolComponent?>> grid;
  late List<Sprite> symbols;
  late double cellSize;
  late double gridWidth;
  late double gridHeight;
  late Vector2 gridPosition;
  bool isSpinning = false;
  final Random random = Random();
  List<EmptyCell> emptyCells = [];

  @override
  void update(double dt) {
    if (!_isPaused) {
      super.update(dt);
    }
  }

  void pauseGame() {
    _isPaused = true;
  }

  void resumeGame() {
    _isPaused = false;
  }

  static void togglePause() {
    final game = instance;
    if (game != null) {
      if (game._isPaused) {
        game.resumeGame();
      } else {
        game.pauseGame();
      }
    }
  }

  @override
  Future<void> onLoad() async {
    initializeGrid();
    createEmptyGrid();
    loadSymbolsAndFill(); // Don't wait for completion
  }

  void initializeGrid() {
    final screenWidth = size.x;
    final screenHeight = size.y;
    final availableWidth = screenWidth * 0.9;
    final availableHeight = screenHeight * 0.7;

    cellSize = min(
      availableWidth / gridCols,
      availableHeight / gridRows,
    );

    spacing = cellSize * 0.08;
    cellSize = min(
      (availableWidth - (spacing * (gridCols - 1))) / gridCols,
      (availableHeight - (spacing * (gridRows - 1))) / gridRows,
    );

    gridWidth = (cellSize * gridCols) + (spacing * (gridCols - 1));
    gridHeight = (cellSize * gridRows) + (spacing * (gridRows - 1));

    // Center the entire grid on screen
    gridPosition = Vector2(
      (screenWidth - gridWidth) / 2,
      (screenHeight - gridHeight) / 3,
    );

    grid = List.generate(
      gridRows,
      (row) => List.generate(gridCols, (col) => null),
    );
  }

  Future<void> loadSymbolsAndFill() async {
    final symbolNames = [
      'candy',
      'cherry',
      'grapes',
      'gummy',
      'jelly',
      'lollipop',
      'orange_candy',
      'orange',
      'strawberry',
      'watermelon',
    ];

    symbols = await Future.wait(
      symbolNames.map((name) => loadSprite('symbols/$name.png')),
    );

    await fillGridWithSymbols();
  }

  @override
  Color backgroundColor() => Colors.transparent;

  void createEmptyGrid() {
    emptyCells.clear();
    for (var row = 0; row < gridRows; row++) {
      for (var col = 0; col < gridCols; col++) {
        final position = Vector2(
          gridPosition.x + (col * (cellSize + spacing)),
          gridPosition.y + (row * (cellSize + spacing)),
        );
        final emptyCell = EmptyCell(
          position: position,
          size: Vector2(cellSize, cellSize),
        );
        emptyCells.add(emptyCell);
        add(emptyCell);
      }
    }
  }

  Future<void> fillGridWithSymbols() async {
    grid = List.generate(
      gridRows,
      (row) => List.generate(gridCols, (col) => null),
    );

    // Fill each column one by one
    for (var col = 0; col < gridCols; col++) {
      // Fill column from bottom to top
      for (var row = gridRows - 1; row >= 0; row--) {
        final startPosition = Vector2(
          gridPosition.x + (col * (cellSize + spacing)),
          gridPosition.y - cellSize * (gridRows - row),
        );

        final targetPosition = Vector2(
          gridPosition.x + (col * (cellSize + spacing)),
          gridPosition.y + (row * (cellSize + spacing)),
        );

        final symbol = SymbolComponent(
          sprite: symbols[random.nextInt(symbols.length)],
          position: startPosition,
          size: Vector2(cellSize, cellSize),
          targetPosition: targetPosition,
        );

        symbol.isAnimating = true;
        symbol.animationProgress = 0.0;

        grid[row][col] = symbol;
        add(symbol);

        // Delay between symbols in column
        await Future.delayed(const Duration(milliseconds: 5));
      }

      // Delay between columns
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }

  Future<void> removeWinningSymbols(List<List<bool>> winningPositions) async {
    int symbolsToRemove = 0;

    // Count symbols to remove
    for (var row = 0; row < gridRows; row++) {
      for (var col = 0; col < gridCols; col++) {
        if (winningPositions[row][col] && grid[row][col] != null) {
          symbolsToRemove++;
        }
      }
    }

    if (symbolsToRemove == 0) return;

    // Calculate win multiplier
    double multiplier = calculateWinMultiplier(winningPositions);

    // Play sound and add credits
    if (multiplier > 0) {
      if (gameState.soundEnabled) {
        gameState.audioService.playSound('win');
      }
      await gameState.addWinnings(multiplier);
      gameState
          .setGameStatusText('YOU WON: ${multiplier.toStringAsFixed(0)}x!');
    }

    // First, completely finish the vanishing animation
    await animateWinningSymbols(winningPositions);

    // Wait additional moment for certainty
    await Future.delayed(const Duration(milliseconds: 200));

    // Only after that start symbol dropping
    await dropSymbolsAfterRemoval();

    // Check for new combinations
    var newWinningPositions = findWinningPositions();
    if (hasWinningCombinations(newWinningPositions)) {
      await removeWinningSymbols(newWinningPositions);
    }
  }

  bool hasWinningCombinations(List<List<bool>> winningPositions) {
    for (var row = 0; row < gridRows; row++) {
      for (var col = 0; col < gridCols; col++) {
        if (winningPositions[row][col]) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> dropSymbolsAfterRemoval() async {
    List<Future> animationFutures = [];

    // Drop existing symbols
    for (var col = 0; col < gridCols; col++) {
      int emptySpot = gridRows - 1;
      while (emptySpot >= 0) {
        if (grid[emptySpot][col] == null) {
          // Look for the nearest symbol above
          int symbolAbove = emptySpot - 1;
          while (symbolAbove >= 0 && grid[symbolAbove][col] == null) {
            symbolAbove--;
          }

          if (symbolAbove >= 0) {
            final symbol = grid[symbolAbove][col]!;
            grid[emptySpot][col] = symbol;
            grid[symbolAbove][col] = null;

            symbol.isAnimating = true;
            symbol.animationProgress = 0.0;
            symbol.targetPosition = Vector2(
              gridPosition.x +
                  (col * (cellSize + spacing)), // Removed cellSize/2
              gridPosition.y + (emptySpot * (cellSize + spacing)),
            );

            animationFutures
                .add(Future.delayed(const Duration(milliseconds: 150)));
          }
        }
        emptySpot--;
      }
    }

    // Add new symbols from top
    for (var col = 0; col < gridCols; col++) {
      for (var row = 0; row < gridRows; row++) {
        if (grid[row][col] == null) {
          final newSymbolFuture = addNewSymbolToColumn(col, row);
          animationFutures.add(newSymbolFuture);
        }
      }
    }

    // Wait for all animations to complete
    await Future.wait(animationFutures);
  }

  Future<void> addNewSymbolToColumn(int col, int row) async {
    final startPosition = Vector2(
      gridPosition.x + (col * (cellSize + spacing)), // Removed cellSize/2
      gridPosition.y - cellSize,
    );
    final targetPosition = Vector2(
      gridPosition.x + (col * (cellSize + spacing)), // Removed cellSize/2
      gridPosition.y + (row * (cellSize + spacing)),
    );

    final symbol = SymbolComponent(
      sprite: symbols[random.nextInt(symbols.length)],
      position: startPosition,
      size: Vector2(cellSize, cellSize),
      targetPosition: targetPosition,
    );

    grid[row][col] = symbol;
    add(symbol);

    return Future.delayed(const Duration(milliseconds: 150));
  }

  List<List<bool>> findWinningPositions() {
    List<List<bool>> winningPositions = List.generate(
      gridRows,
      (row) => List.generate(gridCols, (col) => false),
    );

    // Count the number of each symbol on screen
    Map<Sprite, int> symbolCounts = {};
    Map<Sprite, List<Vector2>> symbolPositions = {};

    for (var row = 0; row < gridRows; row++) {
      for (var col = 0; col < gridCols; col++) {
        if (grid[row][col] != null) {
          final sprite = grid[row][col]!.sprite;
          symbolCounts[sprite] = (symbolCounts[sprite] ?? 0) + 1;

          if (!symbolPositions.containsKey(sprite)) {
            symbolPositions[sprite] = [];
          }
          symbolPositions[sprite]!.add(Vector2(col.toDouble(), row.toDouble()));
        }
      }
    }

    // Find symbols with 7 or more instances
    for (var entry in symbolCounts.entries) {
      if (entry.value >= 7) {
        // Mark all positions of this symbol as winning
        for (var position in symbolPositions[entry.key]!) {
          int col = position.x.toInt();
          int row = position.y.toInt();
          winningPositions[row][col] = true;
        }
      }
    }

    return winningPositions;
  }

  double calculateWinMultiplier(List<List<bool>> winningPositions) {
    Map<Sprite, int> symbolCounts = {};

    // Count the number of each symbol in the winning combination
    for (var row = 0; row < gridRows; row++) {
      for (var col = 0; col < gridCols; col++) {
        if (winningPositions[row][col] && grid[row][col] != null) {
          final sprite = grid[row][col]!.sprite;
          symbolCounts[sprite] = (symbolCounts[sprite] ?? 0) + 1;
        }
      }
    }

    // If no winning symbols, return 0
    if (symbolCounts.isEmpty) return 0;

    // Find the symbol with the highest count
    var maxEntry =
        symbolCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
    int symbolCount = maxEntry.value;

    // Find the symbol index in the symbols array
    int symbolIndex = symbols.indexOf(maxEntry.key);
    if (symbolIndex == -1) return 0;

    // Determine multiplier based on symbol count
    double multiplier = _getSymbolMultiplier(symbolIndex, symbolCount);

    // Calculate win with bet consideration
    double currentBet = gameState.currentBet.toDouble();
    return multiplier * currentBet;
  }

  double _getSymbolMultiplier(int symbolIndex, int symbolCount) {
    // Multiplier rules from the rules dialog
    if (symbolCount < 7) return 0.0; // Minimum 7 symbols for win

    // Determine multiplier based on symbol count
    int multiplierIndex;
    if (symbolCount >= 11) {
      multiplierIndex = 2; // 11+ symbols
    } else if (symbolCount >= 8) {
      multiplierIndex = 1; // 8-10 symbols
    } else {
      multiplierIndex = 0; // 7 symbols
    }

    // Multipliers for each symbol [7, 8-10, 11+]
    final multipliers = [
      [0.5, 1.2, 1.4], // candy
      [0.7, 1.3, 1.4], // orange
      [0.7, 1.3, 1.5], // cherry
      [0.7, 1.3, 1.5], // grapes
      [1.0, 1.4, 1.8], // watermelon
      [1.0, 1.4, 1.8], // strawberry
      [1.2, 1.6, 2.2], // gummy
      [1.2, 1.6, 2.2], // jelly
      [1.2, 1.6, 2.2], // orange_candy
      [1.2, 1.6, 2.2], // lollipop
    ];

    return multipliers[symbolIndex][multiplierIndex];
  }

  static Future<void> spin() async {
    final game = instance;
    if (game == null || game.isSpinning) return;

    game.isSpinning = true;
    game.gameState.setSpinning(true);
    // Show SPINNING... at the start of spin
    game.gameState.setGameStatusText('SPINNING...');
    await game.gameState.deductBet();

    // List to store Future for each column
    List<Future> columnFutures = [];

    // Start removal animation for all columns simultaneously
    for (var col = 0; col < gridCols; col++) {
      columnFutures.add(_animateColumnRemoval(game, col));
    }

    // Wait for all column animations to complete
    await Future.wait(columnFutures);

    // Short pause before new symbols appear
    await Future.delayed(const Duration(milliseconds: 100));

    // Fill with new symbols
    await game.fillGridWithSymbols();

    // Check wins and process them
    bool hasWin;
    bool hadAnyWin = false;
    do {
      final winningPositions = game.findWinningPositions();
      hasWin = game.hasWinningCombinations(winningPositions);

      if (hasWin) {
        hadAnyWin = true;
        // Calculate win
        double multiplier = game.calculateWinMultiplier(winningPositions);

        if (game.gameState.soundEnabled) {
          game.gameState.audioService.playSound('credits_gained');
        }
        await game.gameState.addWinnings(multiplier);
        // Save win status
        game.lastGameStatus = 'YOU WON: ${multiplier.toStringAsFixed(0)}x!';
        game.gameState.setGameStatusText(game.lastGameStatus);

        // Animate vanishing of winning symbols
        await game.animateWinningSymbols(winningPositions);

        // Drop symbols and add new ones
        await game.dropSymbolsAfterRemoval();

        // Wait for animation completion
        await Future.delayed(const Duration(milliseconds: 300));
      } else {
        // Play final sound based on whether there was any win
        if (game.gameState.soundEnabled) {
          if (hadAnyWin) {
            game.gameState.audioService.playSound('win');
          } else {
            game.gameState.audioService.playSound('lose');
          }
        }
        // Save lose status
        game.lastGameStatus = 'PLACE YOUR BETS!';
        game.gameState.setGameStatusText(game.lastGameStatus);
      }
    } while (hasWin); // Continue while there are winning combinations

    game.isSpinning = false;
    game.gameState.setSpinning(false);
    // Restore last status
    game.gameState.setGameStatusText(game.lastGameStatus);
  }

  // New private method for column removal animation
  static Future<void> _animateColumnRemoval(
      SweetBillionsGame game, int col) async {
    // Add delay before starting column animation
    await Future.delayed(Duration(milliseconds: 100 * col));

    // In each column, symbols fall one by one, starting from the bottom
    for (var row = gridRows - 1; row >= 0; row--) {
      if (game.grid[row][col] != null) {
        final symbol = game.grid[row][col]!;

        // Set new target position (below the table)
        symbol.targetPosition = Vector2(
          symbol.position.x,
          game.gridPosition.y + game.gridHeight + game.cellSize,
        );

        // Reset falling animation
        symbol.isAnimating = true;
        symbol.animationProgress = 0.0;

        // Wait for falling animation to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Remove symbol after falling
        symbol.removeFromParent();
        game.grid[row][col] = null;
      }
    }
  }

  void setGameState(GameStateProvider state) {
    gameState = state;
  }

  void handleCascade() async {
    while (hasWinningCombinations(findWinningPositions())) {
      final toRemove = findWinningPositions();
      await removeWinningSymbols(toRemove); // Vanishing animation
      await dropSymbolsAfterRemoval(); // Elements fall down
      await dropSymbolsAfterRemoval(); // Add new ones from top
      await Future.delayed(
          const Duration(milliseconds: 300)); // Animation delay
    }
  }

  Future<void> animateWinningSymbols(List<List<bool>> winningPositions) async {
    // Find all winning symbols
    List<SymbolComponent> winningSymbols = [];
    for (var row = 0; row < gridRows; row++) {
      for (var col = 0; col < gridCols; col++) {
        if (winningPositions[row][col] && grid[row][col] != null) {
          winningSymbols.add(grid[row][col]!);
        }
      }
    }

    // Start vanishing animation
    for (var symbol in winningSymbols) {
      symbol.startVanishingAnimation();
    }

    // Wait for vanishing animation to complete
    await Future.delayed(const Duration(milliseconds: 500));

    // Remove symbols from grid and scene
    for (var row = 0; row < gridRows; row++) {
      for (var col = 0; col < gridCols; col++) {
        if (winningPositions[row][col] && grid[row][col] != null) {
          final symbol = grid[row][col]!;
          symbol.removeFromParent();
          grid[row][col] = null;
        }
      }
    }

    // Additional check that all symbols are removed
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
