// ignore_for_file: cascade_invocations
import 'dart:math';
import 'dart:ui';

import 'package:akillisletme/feature/games/neon_pong/model/pong_ball.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_game_state.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_paddle.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_projectile.dart';
import 'package:akillisletme/feature/games/neon_pong/model/power_up.dart';

/// Power-up spawn, collection, and effect management.
mixin PongPowerUpMixin {
  PongGameState get game;
  Size get gameSize;
  Random get rng;

  /// Power-up effect durations.
  static const _effectDurations = <PowerUpType, double>{
    PowerUpType.widePaddle: 5,
    PowerUpType.magnetic: 8,
    PowerUpType.fireball: 5,
    PowerUpType.freezeAI: 2,
    PowerUpType.shrinkAI: 5,
    PowerUpType.blindAI: 3,
    PowerUpType.slowAI: 4,
  };

  void updatePowerUps(double dt) {
    final w = gameSize.width;
    final h = gameSize.height;

    // Spawn timer.
    game.powerUpTimer += dt;
    if (game.powerUpTimer >= game.powerUpInterval) {
      game.powerUpTimer = 0;
      _spawnPowerUp(w);
    }

    // Falling movement.
    for (final pu in game.fallingPowerUps) {
      pu.y += pu.vy * dt;
      pu.rotation += dt * 2;
    }

    // Paddle collision check.
    _checkPowerUpCollection(w, h);

    // Remove those that went off-screen.
    game.fallingPowerUps.removeWhere((pu) => pu.y > h + 20);

    // Decrease active effect durations.
    _updateActiveEffects(dt);

    // Update player lasers.
    _updatePlayerLasers(dt, h);
  }

  void _spawnPowerUp(double w) {
    const types = PowerUpType.values;
    final type = types[rng.nextInt(types.length)];
    game.fallingPowerUps.add(PowerUp(
      type: type,
      x: 30 + rng.nextDouble() * (w - 60),
      y: 0,
    ));
  }

  void _checkPowerUpCollection(double w, double h) {
    final paddle = game.playerPaddle;
    final paddleTop = h - paddle.y - 16;
    final paddleLeft = paddle.x * w - (paddle.width * w / 2);
    final paddleRight = paddleLeft + paddle.width * w;

    final collected = <PowerUp>[];
    for (final pu in game.fallingPowerUps) {
      if (pu.y + pu.radius >= paddleTop &&
          pu.y - pu.radius <= paddleTop + 10 &&
          pu.x >= paddleLeft &&
          pu.x <= paddleRight) {
        collected.add(pu);
      }
    }

    for (final pu in collected) {
      game.fallingPowerUps.remove(pu);
      activatePowerUp(pu.type);
    }
  }

  void activatePowerUp(PowerUpType type) {
    final duration = _effectDurations[type];
    if (duration != null) {
      game.activeEffects[type] = duration;
    }

    switch (type) {
      case PowerUpType.widePaddle:
        game.playerPaddle.width =
            min(game.playerPaddle.baseWidth * 1.5, 0.5);
      case PowerUpType.magnetic:
        game.playerPaddle.isMagnetic = true;
      case PowerUpType.multiBall:
        _spawnMultiBalls();
      case PowerUpType.fireball:
        for (final ball in game.balls) {
          ball.isFireball = true;
          ball.fireballTimer = 5;
        }
      case PowerUpType.shield:
        game.shieldActive = true;
      case PowerUpType.laser:
        _fireLaserBolts();
      case PowerUpType.freezeAI:
        game.aiPaddle.activeEffects[PaddleEffect.freeze] = 2;
      case PowerUpType.shrinkAI:
        game.aiPaddle.activeEffects[PaddleEffect.shrink] = 5;
      case PowerUpType.blindAI:
        game.aiPaddle.activeEffects[PaddleEffect.blind] = 3;
      case PowerUpType.slowAI:
        game.aiPaddle.activeEffects[PaddleEffect.slow] = 4;
    }
  }

  void _spawnMultiBalls() {
    final existingBalls = List.of(game.balls);
    for (final ball in existingBalls) {
      if (game.balls.length >= PongGameState.maxBalls) break;
      // 2 extra balls (3 total).
      for (var i = 0; i < 2; i++) {
        if (game.balls.length >= PongGameState.maxBalls) break;
        final angle = (rng.nextDouble() - 0.5) * pi * 0.5;
        final speed = ball.speed;
        game.balls.add(PongBall(
          x: ball.x,
          y: ball.y,
          vx: cos(angle) * speed,
          vy: -speed * 0.8,
        ));
      }
    }
  }

  void _fireLaserBolts() {
    final w = gameSize.width;
    final h = gameSize.height;
    final paddle = game.playerPaddle;
    final px = paddle.x * w;
    final py = h - paddle.y - 20;

    // 3 bolts: left, center, right.
    for (var i = -1; i <= 1; i++) {
      game.playerLasers.add(PongProjectile(
        x: px + i * 15,
        y: py,
        vx: i * 30.0,
        vy: -500,
        type: ProjectileType.laser,
        damage: 1,
        lifetime: 2,
      ));
    }
  }

  void _updateActiveEffects(double dt) {
    // Player effects.
    final expiredEffects = <PowerUpType>[];
    for (final entry in game.activeEffects.entries) {
      game.activeEffects[entry.key] = entry.value - dt;
      if (game.activeEffects[entry.key]! <= 0) {
        expiredEffects.add(entry.key);
      }
    }
    for (final type in expiredEffects) {
      game.activeEffects.remove(type);
      _deactivateEffect(type);
    }

    // AI paddle effects.
    final expiredAiEffects = <PaddleEffect>[];
    for (final entry in game.aiPaddle.activeEffects.entries) {
      game.aiPaddle.activeEffects[entry.key] = entry.value - dt;
      if (game.aiPaddle.activeEffects[entry.key]! <= 0) {
        expiredAiEffects.add(entry.key);
      }
    }
    for (final effect in expiredAiEffects) {
      game.aiPaddle.activeEffects.remove(effect);
      if (effect == PaddleEffect.shrink) {
        game.aiPaddle.width = game.aiPaddle.baseWidth;
      }
    }
  }

  void _deactivateEffect(PowerUpType type) {
    switch (type) {
      case PowerUpType.widePaddle:
        game.playerPaddle.width = game.playerPaddle.baseWidth;
      case PowerUpType.magnetic:
        // Release stuck balls BEFORE disabling isMagnetic.
        for (final ball in game.balls) {
          if (ball.vx == 0 && ball.vy == 0) {
            final angle = -pi / 2 + (rng.nextDouble() - 0.5) * pi * 0.3;
            final speed =
                game.levelConfig?.ballSpeed.toDouble() ?? 280.0;
            ball.vx = cos(angle) * speed;
            ball.vy = sin(angle) * speed;
          }
        }
        game.playerPaddle.isMagnetic = false;
        game.playerPaddle.magnetBallRelativeX = null;
      default:
        break;
    }
  }

  void _updatePlayerLasers(double dt, double h) {
    for (final laser in game.playerLasers) {
      laser.x += laser.vx * dt;
      laser.y += laser.vy * dt;
      laser.lifetime -= dt;
    }
    game.playerLasers.removeWhere((l) => l.isExpired || l.y < -20);
  }
}
