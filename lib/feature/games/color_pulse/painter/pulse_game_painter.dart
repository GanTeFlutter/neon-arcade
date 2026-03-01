import 'dart:math';

import 'package:akillisletme/feature/games/color_pulse/model/falling_ball.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// CustomPainter that draws the Color Pulse game area.
class PulseGamePainter extends CustomPainter {
  PulseGamePainter({
    required this.balls,
    required this.ringColor,
    required this.ringPulse,
    required this.lives,
  });

  final List<FallingBall> balls;
  final Color ringColor;

  /// Ring pulse value (0.6-1.0).
  final double ringPulse;
  final int lives;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);

    // Background lines (direction indicators).
    _drawGuideLines(canvas, size, center);

    // Center ring.
    _drawRing(canvas, center);

    // Balls.
    for (final ball in balls) {
      _drawBall(canvas, ball, size);
    }

    // Lives indicator.
    _drawLives(canvas, size);
  }

  void _drawGuideLines(Canvas canvas, Size size, Offset center) {
    final maxDist = min(center.dx, center.dy) * 0.85;
    final linePaint = Paint()
      ..color = NeonColors.textDim.withValues(alpha: 0.06)
      ..strokeWidth = 1;

    for (var i = 0; i < 4; i++) {
      final angle = i * pi / 2;
      final end = Offset(
        center.dx + cos(angle) * maxDist,
        center.dy + sin(angle) * maxDist,
      );
      canvas.drawLine(center, end, linePaint);
    }
  }

  void _drawRing(Canvas canvas, Offset center) {
    const ringRadius = 36.0;

    // Outer glow.
    final glowPaint = Paint()
      ..color = ringColor.withValues(alpha: 0.3 * ringPulse)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, ringRadius + 8, glowPaint);

    // Ring.
    final ringPaint = Paint()
      ..color = ringColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, ringRadius, ringPaint);

    final borderPaint = Paint()
      ..color = ringColor.withValues(alpha: 0.8 * ringPulse)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, ringRadius, borderPaint);

    // Inner glow.
    final innerGlow = Paint()
      ..color = ringColor.withValues(alpha: 0.5 * ringPulse)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center, ringRadius, innerGlow);
  }

  void _drawBall(Canvas canvas, FallingBall ball, Size size) {
    final pos = ball.position(size);

    // Glow.
    final glowPaint = Paint()
      ..color = ball.color.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(pos, ball.radius + 4, glowPaint);

    // Ball.
    final ballPaint = Paint()
      ..color = ball.color.withValues(alpha: 0.8);
    canvas.drawCircle(pos, ball.radius, ballPaint);

    // Inner shine.
    final innerPaint = Paint()
      ..color = ball.color
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(pos, ball.radius * 0.5, innerPaint);
  }

  void _drawLives(Canvas canvas, Size size) {
    const heartSize = 14.0;
    final startX = size.width / 2 - (3 * heartSize + 2 * 6) / 2;
    final y = size.height - 40.0;

    for (var i = 0; i < 3; i++) {
      final x = startX + i * (heartSize + 6);
      final color = i < lives ? NeonColors.red : NeonColors.textDim;
      final paint = Paint()
        ..color = color.withValues(alpha: i < lives ? 0.9 : 0.2);

      if (i < lives) {
        final glow = Paint()
          ..color = color.withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        canvas.drawCircle(Offset(x + heartSize / 2, y), heartSize / 2, glow);
      }
      canvas.drawCircle(
        Offset(x + heartSize / 2, y),
        heartSize / 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(PulseGamePainter oldDelegate) => true;
}
