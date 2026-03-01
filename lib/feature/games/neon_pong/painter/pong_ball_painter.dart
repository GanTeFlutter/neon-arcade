import 'dart:math';

import 'package:akillisletme/feature/games/neon_pong/model/pong_ball.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Draws balls and their speed-based trails.
final class PongBallPainter {
  const PongBallPainter._();

  /// Ball speed colors: blue -> green -> yellow -> red.
  static const _speedColors = [
    NeonColors.cyan,
    NeonColors.green,
    NeonColors.yellow,
    NeonColors.red,
  ];

  static void drawBall(Canvas canvas, PongBall ball) {
    final color = ball.isFireball
        ? const Color(0xFFFF6B35)
        : _speedColors[ball.speedTier];

    // Fireball glow.
    if (ball.isFireball) {
      final fireGlow = Paint()
        ..color = const Color(0xFFFF6B35).withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawCircle(Offset(ball.x, ball.y), ball.radius + 8, fireGlow);
    }

    // Glow.
    final glow = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(ball.x, ball.y), ball.radius + 4, glow);

    // Ball.
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(ball.x, ball.y), ball.radius, paint);

    // Inner glow.
    final inner = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset(ball.x, ball.y), ball.radius * 0.4, inner);
  }

  static void drawTrail(Canvas canvas, PongBall ball) {
    final color = ball.isFireball
        ? const Color(0xFFFF6B35)
        : _speedColors[ball.speedTier];

    for (var i = 0; i < ball.trail.length; i++) {
      final t = ball.trail[i];
      final alpha = (i / ball.trail.length) * 0.3;
      final r = ball.radius * (i / ball.trail.length) * 0.6;
      final paint = Paint()..color = color.withValues(alpha: alpha);
      canvas.drawCircle(t, max(r, 1), paint);
    }
  }
}
