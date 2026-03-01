// ignore_for_file: cascade_invocations, for readability in game loop
import 'dart:async';

import 'package:akillisletme/feature/games/neon_maze/data/maze_generator.dart';
import 'package:akillisletme/feature/games/neon_maze/data/maze_levels.dart';
import 'package:akillisletme/feature/games/neon_maze/model/maze_game_state.dart';
import 'package:akillisletme/feature/games/neon_maze/neon_maze_view.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Neon Maze game logic.
abstract class NeonMazeViewModel extends State<NeonMazeView>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _lastTick = Duration.zero;

  final MazeGameState game = MazeGameState();

  /// Drag control offset (accumulated pan delta).
  double _dragDx = 0;
  double _dragDy = 0;

  /// Cell size (pixels) — used for drag threshold.
  double cellSize = 0;

  /// Control type read from settings.
  String get controlType => locator.sharedCache.mazeControlType;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _loadLevel(widget.initialLevelId);
  }

  void _loadLevel(int levelId) {
    _ticker.stop();
    _lastTick = Duration.zero;

    final level = MazeLevels.getLevel(levelId);
    final grid = MazeGenerator.generate(level.rows, level.cols, levelId * 31);

    game
      ..grid = grid
      ..rows = level.rows
      ..cols = level.cols
      ..playerRow = 0
      ..playerCol = 0
      ..exitRow = level.rows - 1
      ..exitCol = level.cols - 1
      ..trail.clear()
      ..timeLeft = level.timeLimit
      ..totalTime = level.timeLimit
      ..lightRadius = level.lightRadius
      ..levelId = levelId
      ..isGameOver = false
      ..isComplete = false
      ..hasStarted = false
      ..earnedStars = 0;

    // Add initial position to the trail.
    game.trail.add(Offset.zero);

    _dragDx = 0;
    _dragDy = 0;

    setState(() {});
  }

  void startGame() {
    if (game.hasStarted) return;
    game.hasStarted = true;
    _ticker.start();
    setState(() {});
  }

  void restartLevel() {
    _loadLevel(game.levelId);
  }

  void loadLevel(int levelId) {
    _loadLevel(levelId);
  }

  void pauseGame() => _ticker.stop();

  void resumeGame() {
    if (game.hasStarted && !game.isGameOver && !game.isComplete) {
      _lastTick = Duration.zero;
      _ticker.start();
    }
  }

  /// Joystick movement: 0=up, 1=right, 2=down, 3=left.
  void onJoystickMove(int direction) {
    if (!game.hasStarted || game.isGameOver || game.isComplete) return;

    // Start the game if not started yet.
    if (!game.hasStarted) {
      startGame();
      return;
    }

    switch (direction) {
      case 0:
        _tryMove(-1, 0);
      case 1:
        _tryMove(0, 1);
      case 2:
        _tryMove(1, 0);
      case 3:
        _tryMove(0, -1);
    }
  }

  /// Drag/swipe control.
  void onPanUpdate(DragUpdateDetails details) {
    if (!game.hasStarted || game.isGameOver || game.isComplete) return;

    _dragDx += details.delta.dx;
    _dragDy += details.delta.dy;

    final threshold = cellSize * 0.4;

    if (_dragDx.abs() > _dragDy.abs()) {
      // Horizontal movement.
      if (_dragDx > threshold) {
        _tryMove(0, 1);
        _dragDx = 0;
        _dragDy = 0;
      } else if (_dragDx < -threshold) {
        _tryMove(0, -1);
        _dragDx = 0;
        _dragDy = 0;
      }
    } else {
      // Vertical movement.
      if (_dragDy > threshold) {
        _tryMove(1, 0);
        _dragDx = 0;
        _dragDy = 0;
      } else if (_dragDy < -threshold) {
        _tryMove(-1, 0);
        _dragDx = 0;
        _dragDy = 0;
      }
    }
  }

  void onPanEnd() {
    _dragDx = 0;
    _dragDy = 0;
  }

  void _tryMove(int dr, int dc) {
    final r = game.playerRow;
    final c = game.playerCol;
    final nr = r + dr;
    final nc = c + dc;

    // Boundary check.
    if (nr < 0 || nr >= game.rows || nc < 0 || nc >= game.cols) return;

    // Wall check.
    final cell = game.grid[r][c];
    if (dr == -1 && cell.top) return;
    if (dr == 1 && cell.bottom) return;
    if (dc == -1 && cell.left) return;
    if (dc == 1 && cell.right) return;

    // Move.
    game.playerRow = nr;
    game.playerCol = nc;

    // Add to trail (avoid duplicates).
    final newPos = Offset(nc.toDouble(), nr.toDouble());
    if (game.trail.isEmpty || game.trail.last != newPos) {
      game.trail.add(newPos);
    }

    unawaited(locator.audioService.playBlip());
    unawaited(locator.vibrationService.light());

    // Has the exit been reached?
    if (nr == game.exitRow && nc == game.exitCol) {
      _levelComplete();
    }

    setState(() {});
  }

  void _onTick(Duration elapsed) {
    if (game.isGameOver || game.isComplete) return;

    final dt = _lastTick == Duration.zero
        ? 0.016
        : (elapsed - _lastTick).inMicroseconds / 1000000.0;
    _lastTick = elapsed;

    // Decrease time.
    game.timeLeft -= dt;
    if (game.timeLeft <= 0) {
      game.timeLeft = 0;
      _timeUp();
      return;
    }

    setState(() {});
  }

  void _levelComplete() {
    game.isComplete = true;
    game.earnedStars = game.starsForTime();
    _ticker.stop();

    unawaited(locator.audioService.playPerfect());
    unawaited(locator.vibrationService.heavy());
    unawaited(
      locator.scoreService.updateMazeProgress(
        game.levelId,
        game.earnedStars,
      ),
    );

    setState(() {});
  }

  void _timeUp() {
    game.isGameOver = true;
    _ticker.stop();

    unawaited(locator.audioService.playBuzz());
    unawaited(locator.vibrationService.heavy());

    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
