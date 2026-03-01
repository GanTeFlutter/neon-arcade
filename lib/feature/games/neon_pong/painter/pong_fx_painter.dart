import 'package:akillisletme/feature/games/neon_pong/model/pong_particle.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_projectile.dart';
import 'package:akillisletme/feature/games/neon_pong/model/power_up.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Draws power-ups, projectiles, particles, and shield.
final class PongFxPainter {
  const PongFxPainter._();

  // ── Shield ──────────────────────────────────────────────────

  static void drawShield(Canvas canvas, Size size, double paddleY) {
    final y = size.height - paddleY - 4;
    final paint = Paint()
      ..color = NeonColors.yellow.withValues(alpha: 0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

    final glow = Paint()
      ..color = NeonColors.yellow.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
      ..strokeWidth = 4;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), glow);
  }

  // ── Power-up ────────────────────────────────────────────────

  static void drawPowerUp(Canvas canvas, PowerUp pu) {
    // Glow.
    final glow = Paint()
      ..color = pu.type.color.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(pu.x, pu.y), pu.radius + 3, glow);

    // Outer circle.
    final border = Paint()
      ..color = pu.type.color.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(pu.x, pu.y), pu.radius, border);

    // Fill.
    final fill = Paint()..color = pu.type.color.withValues(alpha: 0.15);
    canvas.drawCircle(Offset(pu.x, pu.y), pu.radius, fill);

    // Type indicator: small inner circle.
    final indicator = Paint()..color = pu.type.color.withValues(alpha: 0.6);
    canvas.drawCircle(Offset(pu.x, pu.y), 3, indicator);
  }

  // ── Projectile ──────────────────────────────────────────────

  static void drawProjectile(Canvas canvas, PongProjectile p, Color color) {
    if (p.type == ProjectileType.laser) {
      // Laser beam.
      final laserPaint = Paint()
        ..color = color.withValues(alpha: 0.6)
        ..strokeWidth = p.laserWidth
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawLine(
        Offset(p.x, p.y),
        Offset(p.x + p.vx * 0.05, p.y + p.vy * 0.05),
        laserPaint,
      );

      final corePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.8)
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(p.x, p.y),
        Offset(p.x + p.vx * 0.05, p.y + p.vy * 0.05),
        corePaint,
      );
    } else {
      // Normal projectile.
      final glow = Paint()
        ..color = color.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset(p.x, p.y), p.radius + 2, glow);

      final paint = Paint()..color = color;
      canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
    }
  }

  // ── Particle ────────────────────────────────────────────────

  static void drawParticle(Canvas canvas, PongParticle p) {
    final alpha = p.lifeRatio * 0.8;
    final glow = Paint()
      ..color = p.color.withValues(alpha: alpha * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset(p.x, p.y), p.radius + 1, glow);

    final paint = Paint()..color = p.color.withValues(alpha: alpha);
    canvas.drawCircle(Offset(p.x, p.y), p.radius * p.lifeRatio, paint);
  }
}
