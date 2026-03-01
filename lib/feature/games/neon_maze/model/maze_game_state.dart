import 'dart:ui';

import 'package:akillisletme/feature/games/neon_maze/model/maze_cell.dart';

/// Neon Maze game state.
class MazeGameState {
  MazeGameState();

  /// Maze cells (rows x cols).
  List<List<MazeCell>> grid = [];

  /// Maze dimensions.
  int rows = 0;
  int cols = 0;

  /// Player position (row, column).
  int playerRow = 0;
  int playerCol = 0;

  /// Exit position.
  int exitRow = 0;
  int exitCol = 0;

  /// Player trail (visited cells).
  final List<Offset> trail = [];

  /// Remaining time (seconds).
  double timeLeft = 30;

  /// Total time.
  double totalTime = 30;

  /// Visibility radius (in cell count).
  double lightRadius = 4;

  /// Level ID.
  int levelId = 0;

  /// Whether the game is over (time expired).
  bool isGameOver = false;

  /// Whether the level is completed.
  bool isComplete = false;

  /// Whether the game has started.
  bool hasStarted = false;

  /// Earned stars.
  int earnedStars = 0;

  /// Star calculation: based on remaining time percentage.
  int starsForTime() {
    final ratio = timeLeft / totalTime;
    if (ratio >= 0.5) return 3;
    if (ratio >= 0.25) return 2;
    return 1;
  }
}
