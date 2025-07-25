import 'dart:math';
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/providers/game_state_provider.dart';

class EmptyCell extends PositionComponent {
  EmptyCell({required Vector2 position, required Vector2 size}) {
    this.position = Vector2(
      position.x + size.x / 2,
      position.y + size.y / 2,
    );
    this.size = size;
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, paint);
  }
}

class SymbolComponent extends PositionComponent {
  Sprite sprite;
  Vector2 targetPosition;
  bool isAnimating = true;
  bool isRemoving = false;
  double animationProgress = 0.0;
  double _opacity = 1.0;
  Function? onRemoveComplete;
  bool _hasCalledComplete = false;

  SymbolComponent({
    required this.sprite,
    required Vector2 position,
    required Vector2 size,
    required this.targetPosition,
  }) {
    this.position = Vector2(
      position.x + size.x / 2,
      position.y + size.y / 2,
    );
    this.size = size;
    scale = Vector2.all(1.0);
    anchor = Anchor.center;
  }

  double lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isRemoving) {
      // Проста анімація зникнення
      animationProgress = min(1.0, animationProgress + dt * 4);
      _opacity = max(0, 1 - animationProgress);

      if (animationProgress >= 1.0) {
        if (onRemoveComplete != null && !_hasCalledComplete) {
          _hasCalledComplete = true;
          onRemoveComplete!();
        }
        removeFromParent();
      }
    } else if (isAnimating) {
      // Анімація падіння
      animationProgress =
          min(1.0, animationProgress + dt * 8); // Прискорили падіння

      position = Vector2(
        targetPosition.x + size.x / 2,
        lerp(position.y, targetPosition.y + size.y / 2, animationProgress),
      );

      if (animationProgress >= 1.0) {
        isAnimating = false;
        position = Vector2(
          targetPosition.x + size.x / 2,
          targetPosition.y + size.y / 2,
        );
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();

    // Малюємо фон символу
    final rect = Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5 * _opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, paint);

    // Малюємо символ
    final padding = size.x * 0.01;
    final symbolRect = Rect.fromLTWH(
      -size.x / 2 + padding,
      -size.y / 2 + padding,
      size.x - (padding * 2),
      size.y - (padding * 2),
    );

    final spritePaint = Paint()
      ..color = Colors.white.withOpacity(_opacity)
      ..filterQuality = FilterQuality.high;

    sprite.render(
      canvas,
      position: Vector2(symbolRect.left, symbolRect.top),
      size: Vector2(symbolRect.width, symbolRect.height),
      overridePaint: spritePaint,
    );

    canvas.restore();
  }
}

class SweetBillionsGame extends FlameGame with TapDetector {
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

  @override
  void render(Canvas canvas) {
    super.render(canvas);
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
    loadSymbolsAndFill(); // Не чекаємо завершення
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

    // Центруємо всю сітку на екрані
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
          gridPosition.x + (col * (cellSize + spacing)) + cellSize / 2,
          gridPosition.y + (row * (cellSize + spacing)) + cellSize / 2,
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
        gridRows, (row) => List.generate(gridCols, (col) => null));

    for (var col = 0; col < gridCols; col++) {
      for (var row = gridRows - 1; row >= 0; row--) {
        await Future.delayed(Duration(milliseconds: 50 * col));
        final startPosition = Vector2(
          gridPosition.x + (col * (cellSize + spacing)) + cellSize / 2,
          gridPosition.y - cellSize,
        );
        final targetPosition = Vector2(
          gridPosition.x + (col * (cellSize + spacing)) + cellSize / 2,
          gridPosition.y + (row * (cellSize + spacing)) + cellSize / 2,
        );
        final symbol = SymbolComponent(
          sprite: symbols[random.nextInt(symbols.length)],
          position: startPosition,
          size: Vector2(cellSize, cellSize),
          targetPosition: targetPosition,
        );
        grid[row][col] = symbol;
        add(symbol);
      }
    }
  }

  Future<void> removeWinningSymbols(List<List<bool>> winningPositions) async {
    bool hasRemovedSymbols = false;
    int symbolsToRemove = 0;
    int removedSymbols = 0;
    final completer = Completer<void>();

    // Count symbols to remove
    for (var row = 0; row < gridRows; row++) {
      for (var col = 0; col < gridCols; col++) {
        if (winningPositions[row][col] && grid[row][col] != null) {
          symbolsToRemove++;
        }
      }
    }

    if (symbolsToRemove == 0) {
      return;
    }

    // Calculate win multiplier based on matches
    double multiplier = 0.0;
    if (symbolsToRemove >= 8)
      multiplier = 20.0;
    else if (symbolsToRemove >= 6)
      multiplier = 10.0;
    else if (symbolsToRemove >= 4)
      multiplier = 4.0;
    else if (symbolsToRemove >= 3) multiplier = 2.0;

    // Play win sound and add credits
    if (multiplier > 0) {
      if (gameState.soundEnabled) {
        gameState.audioService.playSound('win');
      }
      await gameState.addWinnings(multiplier);
      gameState
          .setGameStatusText('YOU WON: ${multiplier.toStringAsFixed(0)}x!');
    }

    // Start removing symbols
    for (var row = 0; row < gridRows; row++) {
      for (var col = 0; col < gridCols; col++) {
        if (winningPositions[row][col] && grid[row][col] != null) {
          final symbol = grid[row][col]!;
          hasRemovedSymbols = true;

          symbol.onRemoveComplete = () {
            removedSymbols++;
            if (removedSymbols >= symbolsToRemove && !completer.isCompleted) {
              completer.complete();
            }
          };

          symbol.isRemoving = true;
          grid[row][col] = null;
        }
      }
    }

    if (hasRemovedSymbols) {
      try {
        // Wait for all removal animations
        await completer.future;

        // Drop symbols
        await dropSymbolsAfterRemoval();

        // Check for new combinations
        var newWinningPositions = findWinningPositions();
        if (hasWinningCombinations(newWinningPositions)) {
          await removeWinningSymbols(newWinningPositions);
        }
      } catch (e) {
        print('Error in removeWinningSymbols: $e');
      }
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

    // Опускаємо існуючі символи
    for (var col = 0; col < gridCols; col++) {
      int emptySpot = gridRows - 1;
      while (emptySpot >= 0) {
        if (grid[emptySpot][col] == null) {
          // Шукаємо найближчий символ зверху
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
              gridPosition.x + (col * (cellSize + spacing)),
              gridPosition.y + (emptySpot * (cellSize + spacing)),
            );

            animationFutures.add(Future.delayed(
                    const Duration(milliseconds: 150)) // Зменшили затримку
                );
          }
        }
        emptySpot--;
      }
    }

    // Додаємо нові символи зверху
    for (var col = 0; col < gridCols; col++) {
      for (var row = 0; row < gridRows; row++) {
        if (grid[row][col] == null) {
          final newSymbolFuture = addNewSymbolToColumn(col, row);
          animationFutures.add(newSymbolFuture);
        }
      }
    }

    // Чекаємо завершення всіх анімацій
    await Future.wait(animationFutures);
  }

  Future<void> addNewSymbolToColumn(int col, int row) async {
    final startPosition = Vector2(
      gridPosition.x + (col * (cellSize + spacing)) + cellSize / 2,
      gridPosition.y - cellSize,
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

    grid[row][col] = symbol;
    add(symbol);

    return Future.delayed(
        const Duration(milliseconds: 150)); // Зменшили затримку
  }

  List<List<bool>> findWinningPositions() {
    List<List<bool>> winningPositions = List.generate(
      gridRows,
      (row) => List.generate(gridCols, (col) => false),
    );

    // Горизонтальні комбінації
    for (var row = 0; row < gridRows; row++) {
      for (var col = 0; col < gridCols - 2; col++) {
        if (grid[row][col] != null &&
            grid[row][col + 1] != null &&
            grid[row][col + 2] != null) {
          final sprite1 = grid[row][col]!.sprite;
          final sprite2 = grid[row][col + 1]!.sprite;
          final sprite3 = grid[row][col + 2]!.sprite;

          if (sprite1 == sprite2 && sprite2 == sprite3) {
            // Позначаємо всі символи в комбінації
            winningPositions[row][col] = true;
            winningPositions[row][col + 1] = true;
            winningPositions[row][col + 2] = true;

            // Перевіряємо додаткові символи справа
            if (col + 3 < gridCols &&
                grid[row][col + 3] != null &&
                grid[row][col + 3]!.sprite == sprite1) {
              winningPositions[row][col + 3] = true;

              if (col + 4 < gridCols &&
                  grid[row][col + 4] != null &&
                  grid[row][col + 4]!.sprite == sprite1) {
                winningPositions[row][col + 4] = true;
              }
            }
          }
        }
      }
    }

    // Вертикальні комбінації
    for (var col = 0; col < gridCols; col++) {
      for (var row = 0; row < gridRows - 2; row++) {
        if (grid[row][col] != null &&
            grid[row + 1][col] != null &&
            grid[row + 2][col] != null) {
          final sprite1 = grid[row][col]!.sprite;
          final sprite2 = grid[row + 1][col]!.sprite;
          final sprite3 = grid[row + 2][col]!.sprite;

          if (sprite1 == sprite2 && sprite2 == sprite3) {
            // Позначаємо всі символи в комбінації
            winningPositions[row][col] = true;
            winningPositions[row + 1][col] = true;
            winningPositions[row + 2][col] = true;

            // Перевіряємо додаткові символи знизу
            if (row + 3 < gridRows &&
                grid[row + 3][col] != null &&
                grid[row + 3][col]!.sprite == sprite1) {
              winningPositions[row + 3][col] = true;

              if (row + 4 < gridRows &&
                  grid[row + 4][col] != null &&
                  grid[row + 4][col]!.sprite == sprite1) {
                winningPositions[row + 4][col] = true;
              }
            }
          }
        }
      }
    }

    return winningPositions;
  }

  double checkWins() {
    final winningPositions = findWinningPositions();
    int totalMatches = 0;

    for (var row = 0; row < gridRows; row++) {
      for (var col = 0; col < gridCols; col++) {
        if (winningPositions[row][col]) {
          totalMatches++;
        }
      }
    }

    // Збільшені виплати для більшої частоти виграшів
    if (totalMatches >= 8) return 200.0; // Збільшено з 100 до 200
    if (totalMatches >= 6) return 100.0; // Збільшено з 50 до 100
    if (totalMatches >= 4) return 40.0; // Збільшено з 20 до 40
    if (totalMatches >= 3) return 20.0; // Збільшено з 10 до 20
    return 0.0;
  }

  static Future<void> spin() async {
    final game = instance;
    if (game == null || game.isSpinning) return;

    game.isSpinning = true;
    game.gameState.setSpinning(true);
    await game.gameState.deductBet();

    if (game.gameState.soundEnabled) {
      game.gameState.audioService.playSound('spin_start1');
    }

    // Remove all current symbols with animation
    final futures = <Future>[];
    for (var row = 0; row < gridRows; row++) {
      for (var col = 0; col < gridCols; col++) {
        final symbol = game.grid[row][col];
        if (symbol != null) {
          symbol.isRemoving = true;
          game.grid[row][col] = null;
          futures.add(Future.delayed(const Duration(milliseconds: 300)));
        }
      }
    }

    await Future.wait(futures);
    await game.fillGridWithSymbols();

    // Check for wins
    final winningPositions = game.findWinningPositions();
    if (game.hasWinningCombinations(winningPositions)) {
      await game.removeWinningSymbols(winningPositions);
    } else {
      if (game.gameState.soundEnabled) {
        game.gameState.audioService.playSound('lose');
      }
      game.gameState.setGameStatusText('PLACE YOUR BETS!');
    }

    game.isSpinning = false;
    game.gameState.setSpinning(false);
  }

  void setGameState(GameStateProvider state) {
    gameState = state;
  }
}
