import 'dart:math';

import 'package:akillisletme/feature/games/neon_pong/model/pong_obstacle.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Draws obstacles: portals, blockers, black holes, speed zones, invisible walls.
final class PongObstaclePainter {
  const PongObstaclePainter._();

  static void draw(Canvas canvas, Size size, PongObstacle obs) {
    final rect = Rect.fromLTWH(
      obs.x * size.width,
      obs.y * size.height,
      obs.width * size.width,
      obs.height * size.height,
    );

    switch (obs.type) {
      case ObstacleType.portal:
        _drawPortal(canvas, obs, size);
      case ObstacleType.staticBlocker:
      case ObstacleType.movingBlocker:
        _drawBlocker(canvas, rect, obs.type == ObstacleType.movingBlocker);
      case ObstacleType.blackHole:
        _drawBlackHole(canvas, obs, size);
      case ObstacleType.speedZone:
        _drawSpeedZone(canvas, rect);
      case ObstacleType.invisibleWall:
        _drawInvisibleWall(canvas, rect);
    }
  }

  static void _drawPortal(Canvas canvas, PongObstacle obs, Size size) {
    final center = Offset(
      obs.x * size.width + obs.width * size.width / 2,
      obs.y * size.height + obs.height * size.height / 2,
    );
    final r = obs.width * size.width / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(obs.portalRotation);

    final ringPaint = Paint()
      ..color = NeonColors.magenta.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset.zero, r, ringPaint);

    final ringPaint2 = Paint()
      ..color = NeonColors.cyan.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset.zero, r * 0.7, ringPaint2);

    final glow = Paint()
      ..color = NeonColors.magenta.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset.zero, r + 4, glow);

    canvas.restore();
  }

  static void _drawBlocker(Canvas canvas, Rect rect, bool isMoving) {
    final color = isMoving ? NeonColors.yellow : NeonColors.cyan;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(3));

    final glow = Paint()
      ..color = NeonColors.glowOuter(color)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(rrect, glow);

    final paint = Paint()..color = color.withValues(alpha: 0.8);
    canvas.drawRRect(rrect, paint);

    final border = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rrect, border);
  }

  static void _drawBlackHole(Canvas canvas, PongObstacle obs, Size size) {
    final center = Offset(
      obs.x * size.width + obs.width * size.width / 2,
      obs.y * size.height + obs.height * size.height / 2,
    );
    final r = obs.width * size.width / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(obs.portalRotation * 0.5);

    final corePaint = Paint()
      ..color = const Color(0xFF1A0033)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset.zero, r, corePaint);

    for (var i = 3; i > 0; i--) {
      final glowPaint = Paint()
        ..color = NeonColors.magenta.withValues(alpha: 0.1 * i)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0 * i);
      canvas.drawCircle(Offset.zero, r + 4.0 * i, glowPaint);
    }

    final spiralPaint = Paint()
      ..color = NeonColors.magenta.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path();
    for (var t = 0.0; t < 4 * pi; t += 0.1) {
      final sr = r * 0.3 + r * 0.7 * t / (4 * pi);
      final x = cos(t) * sr;
      final y = sin(t) * sr;
      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, spiralPaint);

    canvas.restore();
  }

  static void _drawSpeedZone(Canvas canvas, Rect rect) {
    final fill = Paint()..color = NeonColors.green.withValues(alpha: 0.08);
    canvas.drawRect(rect, fill);

    final border = Paint()
      ..color = NeonColors.green.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(rect, border);

    final arrowPaint = Paint()
      ..color = NeonColors.green.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final cy = rect.center.dy;
    for (var i = 0; i < 3; i++) {
      final x = rect.left + rect.width * (0.25 + i * 0.25);
      canvas.drawLine(Offset(x - 4, cy - 4), Offset(x, cy), arrowPaint);
      canvas.drawLine(Offset(x, cy), Offset(x - 4, cy + 4), arrowPaint);
    }
  }

  static void _drawInvisibleWall(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawRect(rect, paint);

    final dotPaint = Paint()..color = Colors.white.withValues(alpha: 0.15);
    const spacing = 10.0;
    for (var y = rect.top; y < rect.bottom; y += spacing) {
      canvas.drawCircle(Offset(rect.center.dx, y), 1, dotPaint);
    }
  }
}
