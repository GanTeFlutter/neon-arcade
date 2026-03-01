import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Maze level definitions.
class MazeLevel {
  const MazeLevel({
    required this.id,
    required this.rows,
    required this.cols,
    required this.timeLimit,
    required this.lightRadius,
  });

  final int id;
  final int rows;
  final int cols;

  /// Time limit (seconds).
  final double timeLimit;

  /// Visibility radius (in cell count).
  final double lightRadius;

  Color get tierColor {
    if (id <= 10) return NeonColors.cyan;
    if (id <= 20) return NeonColors.magenta;
    if (id <= 30) return NeonColors.green;
    if (id <= 40) return NeonColors.yellow;
    return NeonColors.red;
  }

  String get tierName {
    if (id <= 10) return 'EASY';
    if (id <= 20) return 'MEDIUM';
    if (id <= 30) return 'HARD';
    if (id <= 40) return 'EXPERT';
    return 'MASTER';
  }
}

/// 50 maze levels.
final class MazeLevels {
  MazeLevels._();

  static final List<MazeLevel> all = _generate();

  static MazeLevel getLevel(int id) => all[id - 1];

  static List<MazeLevel> _generate() {
    final levels = <MazeLevel>[];

    // Tier 1 (1-10): 8x8, 30s, wide light
    for (var i = 1; i <= 10; i++) {
      levels.add(MazeLevel(
        id: i,
        rows: 8,
        cols: 8,
        timeLimit: 30,
        lightRadius: 4,
      ));
    }

    // Tier 2 (11-20): 10x10, 25s, medium light
    for (var i = 11; i <= 20; i++) {
      levels.add(MazeLevel(
        id: i,
        rows: 10,
        cols: 10,
        timeLimit: 25,
        lightRadius: 3.5,
      ));
    }

    // Tier 3 (21-30): 12x12, 25s, narrow light
    for (var i = 21; i <= 30; i++) {
      levels.add(MazeLevel(
        id: i,
        rows: 12,
        cols: 12,
        timeLimit: 25,
        lightRadius: 3,
      ));
    }

    // Tier 4 (31-40): 15x15, 22s, narrow light
    for (var i = 31; i <= 40; i++) {
      levels.add(MazeLevel(
        id: i,
        rows: 15,
        cols: 15,
        timeLimit: 22,
        lightRadius: 2.5,
      ));
    }

    // Tier 5 (41-50): 18x18, 20s, very narrow light
    for (var i = 41; i <= 50; i++) {
      levels.add(MazeLevel(
        id: i,
        rows: 18,
        cols: 18,
        timeLimit: 20,
        lightRadius: 2,
      ));
    }

    return levels;
  }
}
