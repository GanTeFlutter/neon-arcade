// ignore_for_file: cascade_invocations
import 'dart:math';
import 'dart:ui';

import 'package:akillisletme/feature/games/neon_pong/model/pong_ball.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_game_state.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_level_config.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_paddle.dart';

/// Ball physics calculations.
mixin PongBallPhysicsMixin {
  PongGameState get game;
  Size get gameSize;
  Random get rng;

  static const _initialBallSpeed = 280.0;

  void spawnBall({double? speed, double? targetX}) {
    if (game.balls.length >= PongGameState.maxBalls) return;
    final w = gameSize.width;
    final h = gameSize.height;
    final s = speed ?? game.levelConfig?.ballSpeed.toDouble() ?? _initialBallSpeed;
    final angle = -pi / 2 + (rng.nextDouble() - 0.5) * pi / 3;
    game.balls.add(PongBall(
      x: targetX ?? w / 2,
      y: h / 2,
      vx: cos(angle) * s,
      vy: sin(angle) * s,
    ));
  }

  /// Ball movement and wall collision. Returns goal status.
  /// Returned list: bottom losses (player lost the goal), top losses (AI lost the goal).
  ({List<PongBall> playerLost, List<PongBall> aiLost}) updateBalls(double dt) {
    final w = gameSize.width;
    final h = gameSize.height;
    final playerLost = <PongBall>[];
    final aiLost = <PongBall>[];

    for (final ball in game.balls) {
      ball.updateTrail();

      // Spin effect: lateral deviation.
      ball.vx += ball.spin * dt * 20;
      ball.spin *= 0.98;

      ball.x += ball.vx * dt;
      ball.y += ball.vy * dt;

      // Left-right wall.
      if (ball.x - ball.radius <= 0) {
        ball.x = ball.radius;
        ball.vx = ball.vx.abs();
      } else if (ball.x + ball.radius >= w) {
        ball.x = w - ball.radius;
        ball.vx = -ball.vx.abs();
      }

      // Top wall bounce in endless mode (no AI paddle).
      if (game.mode == PongMode.endless) {
        if (ball.y - ball.radius <= 0) {
          ball.y = ball.radius;
          ball.vy = ball.vy.abs();
        }
      }

      // Portal cooldown.
      if (ball.portalCooldown > 0) {
        ball.portalCooldown -= dt;
      }

      // Fireball timer.
      if (ball.isFireball) {
        ball.fireballTimer -= dt;
        if (ball.fireballTimer <= 0) {
          ball.isFireball = false;
        }
      }

      // Bottom boundary — player lost the goal.
      if (ball.y - ball.radius > h) {
        if (game.shieldActive) {
          ball.vy = -ball.vy.abs();
          ball.y = h - ball.radius;
          game.shieldActive = false;
        } else {
          playerLost.add(ball);
        }
      }

      // Top boundary — AI lost the goal (ball went past the top in campaign/quickMatch).
      if (ball.y + ball.radius < 0) {
        aiLost.add(ball);
      }
    }

    return (playerLost: playerLost, aiLost: aiLost);
  }

  /// Paddle collision check.
  bool checkPaddleCollision(PongBall ball, PongPaddle paddle, double dt, {bool isPlayer = true}) {
    final w = gameSize.width;
    final h = gameSize.height;
    final paddleTop = isPlayer
        ? h - paddle.y - 16
        : paddle.y + 6;
    final paddleLeft = paddle.x * w - (paddle.width * w / 2);
    final paddleRight = paddleLeft + paddle.width * w;

    // Collision band: speed-based dynamic band (wider at high speeds).
    final speedFactor = ball.speed;
    final band = (15 + speedFactor * 0.02).clamp(15.0, 30.0);

    final bool hitVertical;
    if (isPlayer) {
      hitVertical = ball.vy > 0 &&
          ball.y + ball.radius >= paddleTop &&
          ball.y + ball.radius <= paddleTop + band;
    } else {
      hitVertical = ball.vy < 0 &&
          ball.y - ball.radius <= paddleTop &&
          ball.y - ball.radius >= paddleTop - band;
    }

    if (hitVertical && ball.x >= paddleLeft && ball.x <= paddleRight) {
      final relativeHit =
          (ball.x - paddleLeft) / (paddleRight - paddleLeft);

      // Magnetic paddle: stick the ball.
      if (isPlayer && paddle.isMagnetic) {
        paddle.magnetBallRelativeX = relativeHit;
        ball.vx = 0;
        ball.vy = 0;
        ball.y = paddleTop - ball.radius;
        return true;
      }

      final angle = isPlayer
          ? -pi / 2 + (relativeHit - 0.5) * pi * 0.7
          : pi / 2 + (relativeHit - 0.5) * pi * 0.7;
      final increment = game.levelConfig?.ballSpeedIncrement ?? 1.02;
      final currentSpeed = ball.speed * increment;
      ball.vx = cos(angle) * currentSpeed;
      ball.vy = sin(angle) * currentSpeed;
      ball.y = isPlayer ? paddleTop - ball.radius : paddleTop + ball.radius;

      // Add spin: spin on hits near paddle edges.
      ball.spin = (relativeHit - 0.5) * 3;

      return true;
    }
    return false;
  }

  /// Release the ball from the magnetic paddle.
  void releaseMagneticBall() {
    final paddle = game.playerPaddle;
    if (!paddle.isMagnetic || paddle.magnetBallRelativeX == null) return;

    for (final ball in game.balls) {
      if (ball.vx == 0 && ball.vy == 0) {
        final angle = -pi / 2 + (paddle.magnetBallRelativeX! - 0.5) * pi * 0.5;
        final speed = game.levelConfig?.ballSpeed.toDouble() ?? _initialBallSpeed;
        ball.vx = cos(angle) * speed;
        ball.vy = sin(angle) * speed;
      }
    }
    paddle.magnetBallRelativeX = null;
  }
}
