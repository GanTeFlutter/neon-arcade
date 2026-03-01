import 'dart:math';

import 'package:flutter/material.dart';

/// A single ball falling towards the center.
class FallingBall {
  FallingBall({
    required this.color,
    required this.angle,
    required this.speed,
    this.radius = 14,
  }) : progress = 0;

  /// The ball's color (used to check if it matches the ring).
  final Color color;

  /// Approach angle (radians, 0=right, pi/2=top).
  final double angle;

  /// Movement speed (normalized units per second, 0->1 = edge to center).
  final double speed;

  /// Ball radius (pixels).
  final double radius;

  /// Progress: 0.0 = edge, 1.0 = center.
  double progress;

  /// Calculate the ball's position.
  Offset position(Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxDist = min(cx, cy) * 0.85;
    final dist = maxDist * (1 - progress);
    return Offset(
      cx + cos(angle) * dist,
      cy + sin(angle) * dist,
    );
  }

  /// Whether it has reached the center.
  bool get reachedCenter => progress >= 1;
}
