import 'package:akillisletme/feature/games/neon_pong/model/pong_boss.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Draws the boss paddle with rage glow and shield effects.
final class PongBossPainter {
  const PongBossPainter._();

  static void draw(Canvas canvas, Size size, PongBoss boss) {
    final pw = boss.paddleWidth * size.width;
    final px = boss.x * size.width - pw / 2;
    final py = boss.y;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(px, py, pw, 12),
      const Radius.circular(6),
    );

    final color = boss.isRaging ? NeonColors.red : NeonColors.magenta;

    // Rage glow.
    if (boss.isRaging) {
      final rageGlow = Paint()
        ..color = NeonColors.red.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(px - 6, py - 6, pw + 12, 24),
          const Radius.circular(12),
        ),
        rageGlow,
      );
    }

    // Shield glow.
    if (boss.shieldActive) {
      final shieldGlow = Paint()
        ..color = NeonColors.cyan.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(px - 8, py - 8, pw + 16, 28),
          const Radius.circular(14),
        ),
        shieldGlow,
      );

      final shieldBorder = Paint()
        ..color = NeonColors.cyan.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(px - 4, py - 4, pw + 8, 20),
          const Radius.circular(10),
        ),
        shieldBorder,
      );
    }

    // Glow.
    final glow = Paint()
      ..color = NeonColors.glowOuter(color)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawRRect(rect, glow);

    // Boss paddle.
    final paint = Paint()..color = color;
    canvas.drawRRect(rect, paint);

    // Inner glow.
    final inner = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(px + pw * 0.2, py + 2, pw * 0.6, 3),
        const Radius.circular(1.5),
      ),
      inner,
    );
  }
}
