import 'package:akillisletme/feature/games/neon_pong/model/pong_paddle.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Draws player and AI paddles with effects (freeze, magnetic).
final class PongPaddlePainter {
  const PongPaddlePainter._();

  static void drawPaddle(
    Canvas canvas,
    Size size,
    PongPaddle paddle,
    Color color, {
    required bool isPlayer,
  }) {
    final pw = paddle.width * size.width;
    final px = paddle.x * size.width - pw / 2;
    final py = isPlayer ? size.height - paddle.y - 16 : paddle.y;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(px, py, pw, 10),
      const Radius.circular(5),
    );

    // Freeze effect.
    final effectColor = paddle.isFrozen
        ? const Color(0xFF88DDFF)
        : paddle.isMagnetic
            ? NeonColors.cyan
            : color;

    // Glow.
    final glow = Paint()
      ..color = NeonColors.glowOuter(effectColor)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawRRect(rect, glow);

    // Paddle.
    final paint = Paint()..color = effectColor;
    canvas.drawRRect(rect, paint);

    // Magnetic glow.
    if (paddle.isMagnetic && paddle.magnetBallRelativeX != null) {
      final magnetGlow = Paint()
        ..color = NeonColors.cyan.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(px - 4, py - 4, pw + 8, 18),
          const Radius.circular(9),
        ),
        magnetGlow,
      );
    }
  }
}
