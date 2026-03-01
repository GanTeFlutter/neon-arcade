// ignore_for_file: cascade_invocations, for readability in game loop
import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:akillisletme/feature/games/neon_pong/game/mixin/pong_ball_physics_mixin.dart';
import 'package:akillisletme/feature/games/neon_pong/game/mixin/pong_effects_mixin.dart';
import 'package:akillisletme/feature/games/neon_pong/game/mixin/pong_particle_mixin.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_ball.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_boss.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_game_state.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_projectile.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/service/service_locator.dart';

/// Boss movement, attack patterns, projectiles, and hit detection.
mixin PongBossMixin
    on PongBallPhysicsMixin, PongParticleMixin, PongEffectsMixin {
  @override
  PongGameState get game;
  @override
  Size get gameSize;
  @override
  Random get rng;

  /// Called when boss is defeated. Must be provided by the host.
  void onBossDefeated();

  /// Called when player loses all lives. Must be provided by the host.
  void onGameOver();

  void updateBossMovement(double dt) {
    final boss = game.boss!;
    final w = gameSize.width;
    final rageMul = boss.isRaging ? 1.6 : 1.0;

    // Ball tracking — move towards predicted impact point.
    if (game.balls.isNotEmpty) {
      final approaching = game.balls.where((b) => b.vy < 0).toList();
      if (approaching.isNotEmpty) {
        approaching.sort((a, b) => a.y.compareTo(b.y));
        final target = approaching.first;
        final timeToReach = (target.y - boss.y) / (-target.vy);
        var predictedX = target.x + target.vx * timeToReach;
        // Wall reflections.
        while (predictedX < 0 || predictedX > w) {
          if (predictedX < 0) predictedX = -predictedX;
          if (predictedX > w) predictedX = 2 * w - predictedX;
        }
        final targetNorm = predictedX / w;
        final diff = targetNorm - boss.x;
        final maxMove = boss.moveSpeed / w * dt * rageMul;
        if (diff.abs() > maxMove) {
          boss.x += maxMove * diff.sign;
        } else {
          boss.x = targetNorm;
        }
      } else {
        // Ball not approaching — patrolling.
        boss.x += boss.direction * boss.moveSpeed * 0.5 / w * dt * rageMul;
      }
    } else {
      boss.x += boss.direction * boss.moveSpeed * 0.5 / w * dt * rageMul;
    }

    // Boundary check.
    if (boss.x >= 1 - boss.paddleWidth / 2) {
      boss.x = 1 - boss.paddleWidth / 2;
      boss.direction = -1;
    } else if (boss.x <= boss.paddleWidth / 2) {
      boss.x = boss.paddleWidth / 2;
      boss.direction = 1;
    }
  }

  void updateBossAttack(double dt) {
    final boss = game.boss!;
    boss.attackCooldown += dt;

    if (boss.shieldActive) {
      boss.shieldTimer -= dt;
      if (boss.shieldTimer <= 0) boss.shieldActive = false;
    }

    if (boss.attackCooldown >= boss.attackInterval) {
      boss.attackCooldown = 0;
      _executeBossAttack(boss);
      boss.nextPattern();
    }
  }

  void _executeBossAttack(PongBoss boss) {
    final w = gameSize.width;
    final spd = boss.currentProjectileSpeed;

    switch (boss.currentPattern) {
      case BossAttackPattern.spreadShot:
        final count = boss.isRaging ? 7 : 5;
        for (var i = 0; i < count; i++) {
          final angle = pi / 2 + (i - count / 2) * 0.25;
          game.bossProjectiles.add(PongProjectile(
            x: boss.x * w, y: boss.y + 20,
            vx: cos(angle) * spd, vy: sin(angle) * spd,
            lifetime: 5,
          ));
        }

      case BossAttackPattern.crystalShield:
        boss.shieldActive = true;
        boss.shieldTimer = boss.isRaging ? 4.0 : 3.0;
        if (boss.isRaging) {
          for (var i = 0; i < 4; i++) {
            final angle = pi / 2 + (i - 1.5) * 0.4;
            game.bossProjectiles.add(PongProjectile(
              x: boss.x * w, y: boss.y + 20,
              vx: cos(angle) * spd * 0.7, vy: sin(angle) * spd * 0.7,
              lifetime: 4,
            ));
          }
        }

      case BossAttackPattern.laserBeam:
        game.bossProjectiles.add(PongProjectile(
          x: boss.x * w, y: boss.y + 20, vx: 0, vy: spd * 1.4,
          type: ProjectileType.laser, lifetime: 3,
        ));
        if (boss.isRaging) {
          game.bossProjectiles.add(PongProjectile(
            x: boss.x * w - 40, y: boss.y + 20, vx: 0, vy: spd * 1.2,
            type: ProjectileType.laser, lifetime: 3,
          ));
          game.bossProjectiles.add(PongProjectile(
            x: boss.x * w + 40, y: boss.y + 20, vx: 0, vy: spd * 1.2,
            type: ProjectileType.laser, lifetime: 3,
          ));
        }

      case BossAttackPattern.areaBlast:
        final count = boss.isRaging ? 12 : 8;
        for (var i = 0; i < count; i++) {
          final angle = i * 2 * pi / count;
          game.bossProjectiles.add(PongProjectile(
            x: boss.x * w, y: boss.y + 20,
            vx: cos(angle) * spd * 0.85, vy: sin(angle) * spd * 0.85,
            lifetime: 5,
          ));
        }

      case BossAttackPattern.cloneSpawn:
        final maxClones = boss.isRaging ? 4 : 3;
        if (game.balls.length < maxClones) {
          spawnBall(speed: spd * 1.1, targetX: boss.x * w);
          if (boss.isRaging && game.balls.length < maxClones) {
            spawnBall(
              speed: spd * 1.0,
              targetX: boss.x * w + (rng.nextBool() ? 50 : -50),
            );
          }
        }

      case BossAttackPattern.screenBlackout:
        triggerChromaticAberration(intensity: boss.isRaging ? 8 : 5);
        triggerShake(duration: boss.isRaging ? 0.8 : 0.5);
        for (var i = 0; i < (boss.isRaging ? 6 : 3); i++) {
          final rx = rng.nextDouble() * w;
          game.bossProjectiles.add(PongProjectile(
            x: rx, y: boss.y + 20,
            vx: (rng.nextDouble() - 0.5) * 60, vy: spd * 0.9,
            lifetime: 4,
          ));
        }
    }
  }

  void updateBossProjectiles(double dt) {
    for (final p in game.bossProjectiles) {
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.lifetime -= dt;
    }
    game.bossProjectiles
        .removeWhere((p) => p.isExpired || p.y > gameSize.height + 20);

    _checkBossProjectileHit();
  }

  void _checkBossProjectileHit() {
    final paddle = game.playerPaddle;
    final w = gameSize.width;
    final h = gameSize.height;
    final paddleTop = h - paddle.y - 16;
    final paddleLeft = paddle.x * w - (paddle.width * w / 2);
    final paddleRight = paddleLeft + paddle.width * w;

    final hit = <PongProjectile>[];
    for (final p in game.bossProjectiles) {
      if (p.y + p.radius >= paddleTop &&
          p.y - p.radius <= paddleTop + 20 &&
          p.x >= paddleLeft - 10 &&
          p.x <= paddleRight + 10) {
        hit.add(p);
      }
    }

    for (final p in hit) {
      game.bossProjectiles.remove(p);
      game.lives--;
      unawaited(locator.audioService.playBuzz());
      unawaited(locator.vibrationService.heavy());
      triggerShake();

      checkLastLifeSlowMotion();

      if (game.lives <= 0) {
        onGameOver();
        return;
      }
    }
  }

  void checkBossPaddleHit(PongBall ball, double dt) {
    final boss = game.boss!;
    final w = gameSize.width;
    final bossTop = boss.y + 6;
    final bossLeft = boss.x * w - (boss.paddleWidth * w / 2);
    final bossRight = bossLeft + boss.paddleWidth * w;

    final band = (15 + ball.speed * 0.02).clamp(15.0, 30.0);

    if (ball.vy < 0 &&
        ball.y - ball.radius <= bossTop &&
        ball.y - ball.radius >= bossTop - band &&
        ball.x >= bossLeft &&
        ball.x <= bossRight) {
      if (boss.shieldActive) {
        ball.vy = ball.vy.abs();
        ball.y = bossTop + ball.radius + 1;
      } else {
        final relativeHit =
            (ball.x - bossLeft) / (bossRight - bossLeft);
        final angle = pi / 2 + (relativeHit - 0.5) * pi * 0.7;
        final currentSpeed = ball.speed * 1.02;
        ball.vx = cos(angle) * currentSpeed;
        ball.vy = sin(angle) * currentSpeed;
        ball.y = bossTop + ball.radius + 1;
      }
    }
  }

  void checkLaserBossHit() {
    if (game.boss == null || game.playerLasers.isEmpty) return;
    final boss = game.boss!;
    final w = gameSize.width;
    final bossLeft = boss.x * w - (boss.paddleWidth * w / 2);
    final bossRight = bossLeft + boss.paddleWidth * w;

    final hit = <PongProjectile>[];
    for (final laser in game.playerLasers) {
      if (laser.y <= boss.y + 20 &&
          laser.x >= bossLeft - 5 &&
          laser.x <= bossRight + 5) {
        hit.add(laser);
      }
    }

    for (final laser in hit) {
      game.playerLasers.remove(laser);
      if (!boss.shieldActive) {
        boss.takeDamage(1);
        unawaited(locator.audioService.playBlip());
        unawaited(locator.vibrationService.light());
        spawnParticles(laser.x, boss.y, NeonColors.red, count: 10);

        if (boss.isDead) {
          onBossDefeated();
          return;
        }
      }
    }
  }
}
