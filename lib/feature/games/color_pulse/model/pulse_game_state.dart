import 'package:akillisletme/feature/games/color_pulse/model/falling_ball.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Color Pulse game state.
class PulseGameState {
  PulseGameState();

  /// Active balls.
  final List<FallingBall> balls = [];

  /// The ring's current color.
  Color ringColor = gameColors[0];

  /// Ring color index.
  int ringColorIndex = 0;

  /// Score.
  int score = 0;

  /// Remaining lives (max 3).
  int lives = 3;

  /// Combo counter.
  int combo = 0;

  /// Whether the game is over.
  bool isGameOver = false;

  /// Whether the game has started.
  bool hasStarted = false;

  /// Ball spawn timer.
  double spawnTimer = 0;

  /// Ring color change timer.
  double ringTimer = 0;

  /// Ball spawn interval (seconds).
  double spawnInterval = 1.8;

  /// Ring color change interval (seconds).
  double ringInterval = 2;

  /// Ball speed.
  double ballSpeed = 0.35;

  /// Game colors.
  static const List<Color> gameColors = [
    NeonColors.cyan,
    NeonColors.magenta,
    NeonColors.green,
    NeonColors.yellow,
  ];
}
