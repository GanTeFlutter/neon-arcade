import 'package:akillisletme/feature/games/neon_pong/model/pong_game_state.dart';
import 'package:akillisletme/feature/games/neon_pong/painter/pong_ball_painter.dart';
import 'package:akillisletme/feature/games/neon_pong/painter/pong_boss_painter.dart';
import 'package:akillisletme/feature/games/neon_pong/painter/pong_fx_painter.dart';
import 'package:akillisletme/feature/games/neon_pong/painter/pong_obstacle_painter.dart';
import 'package:akillisletme/feature/games/neon_pong/painter/pong_paddle_painter.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Main Neon Pong painter — orchestrates sub-painters.
class PongGamePainter extends CustomPainter {
  PongGamePainter({required this.state, required this.gameSize});

  final PongGameState state;
  final Size gameSize;

  static const _playerPaddleColor = NeonColors.cyan;
  static const _aiPaddleColor = NeonColors.red;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackgroundGrid(canvas, size);
    _drawCenterLine(canvas, size);

    // Obstacles.
    for (final obs in state.obstacles) {
      if (obs.isActive) PongObstaclePainter.draw(canvas, size, obs);
    }

    // Shield.
    if (state.shieldActive) {
      PongFxPainter.drawShield(canvas, size, state.playerPaddle.y);
    }

    // Power-ups.
    for (final pu in state.fallingPowerUps) {
      PongFxPainter.drawPowerUp(canvas, pu);
    }

    // AI paddle or boss.
    if (state.boss != null) {
      PongBossPainter.draw(canvas, size, state.boss!);
    } else {
      PongPaddlePainter.drawPaddle(
        canvas, size, state.aiPaddle, _aiPaddleColor,
        isPlayer: false,
      );
    }

    // Player paddle.
    PongPaddlePainter.drawPaddle(
      canvas, size, state.playerPaddle, _playerPaddleColor,
      isPlayer: true,
    );

    // Balls.
    for (final ball in state.balls) {
      PongBallPainter.drawTrail(canvas, ball);
      PongBallPainter.drawBall(canvas, ball);
    }

    // Boss projectiles.
    for (final p in state.bossProjectiles) {
      PongFxPainter.drawProjectile(canvas, p, NeonColors.red);
    }

    // Player lasers.
    for (final l in state.playerLasers) {
      PongFxPainter.drawProjectile(canvas, l, NeonColors.cyan);
    }

    // Particles.
    for (final p in state.particles) {
      PongFxPainter.drawParticle(canvas, p);
    }
  }

  void _drawBackgroundGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = NeonColors.textDim.withValues(alpha: 0.04)
      ..strokeWidth = 0.5;

    const spacing = 30.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawCenterLine(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = NeonColors.textDim.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    final dashWidth = 8.0;
    final dashSpace = 6.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(x + dashWidth, size.height / 2),
        paint,
      );
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(PongGamePainter oldDelegate) => true;
}
