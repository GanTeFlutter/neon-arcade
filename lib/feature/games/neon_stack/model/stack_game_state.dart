import 'package:flutter/material.dart';

/// A single stacked block.
@immutable
class StackBlock {
  const StackBlock({
    required this.left,
    required this.width,
    required this.color,
    this.isPerfect = false,
  });

  /// Left edge of the block (0.0 – 1.0 normalized).
  final double left;

  /// Width of the block (0.0 – 1.0 normalized).
  final double width;

  /// Color of the block.
  final Color color;

  /// Whether it was placed with PERFECT alignment.
  final bool isPerfect;

  double get right => left + width;
  double get center => left + width / 2;
}

/// Full game state.
class StackGameState {
  StackGameState();

  /// Stacked blocks (bottom to top).
  final List<StackBlock> blocks = [];

  /// Current x position of the moving block (0.0 – 1.0).
  double movingX = 0;

  /// Width of the moving block.
  double movingWidth = 0.4;

  /// Movement direction: 1 = right, -1 = left.
  int direction = 1;

  /// Movement speed (normalized units per second).
  double speed = 0.6;

  /// Score.
  int score = 0;

  /// Consecutive PERFECT count.
  int combo = 0;

  /// Whether the game is over.
  bool isGameOver = false;

  /// Whether the game has started (first tap).
  bool hasStarted = false;

  /// PERFECT tolerance (normalized units).
  static const double perfectTolerance = 0.015;

  /// Width expansion amount per combo.
  static const double comboWidthBonus = 0.02;

  /// Speed increase rate (every 10 blocks).
  static const double speedIncrement = 0.08;

  /// Maximum speed.
  static const double maxSpeed = 1.8;
}
