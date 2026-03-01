// ignore_for_file: cascade_invocations, for readability in game loop
import 'dart:math';
import 'dart:ui';

import 'package:akillisletme/feature/games/neon_pong/game/mixin/pong_particle_mixin.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_ball.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_game_state.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_obstacle.dart';
import 'package:akillisletme/product/const/neon_colors.dart';

/// Obstacle updates and collision logic (portals, blockers, black holes, etc.).
mixin PongObstacleMixin on PongParticleMixin {
  @override
  PongGameState get game;
  Size get gameSize;

  void updateObstacles(double dt) {
    final w = gameSize.width;
    for (final obs in game.obstacles) {
      if (!obs.isActive) continue;

      if (obs.type == ObstacleType.portal) {
        obs.portalRotation += dt * 2;
      }

      if (obs.type == ObstacleType.movingBlocker) {
        final pixelX = obs.x * w;
        final newX = pixelX + obs.movingSpeed * obs.movingDirection * dt;
        final minX = (obs.movingMinX ?? 0.05) * w;
        final maxX = (obs.movingMaxX ?? 0.95) * w;

        if (newX <= minX) {
          obs.movingDirection = 1;
          obs.x = minX / w;
        } else if (newX + obs.width * w >= maxX) {
          obs.movingDirection = -1;
          obs.x = (maxX - obs.width * w) / w;
        } else {
          obs.x = newX / w;
        }
      }
    }
  }

  void checkObstacleCollision(PongBall ball, double w, double h) {
    for (final obs in game.obstacles) {
      if (!obs.isActive) continue;

      final obsRect = Rect.fromLTWH(
        obs.x * w, obs.y * h, obs.width * w, obs.height * h,
      );
      final ballCenter = Offset(ball.x, ball.y);
      final ballRect =
          Rect.fromCircle(center: ballCenter, radius: ball.radius);

      switch (obs.type) {
        case ObstacleType.portal:
          if (ballRect.overlaps(obsRect) &&
              obs.pairedPortalIndex != null &&
              obs.pairedPortalIndex! < game.obstacles.length &&
              obs.pairedPortalIndex! != game.obstacles.indexOf(obs) &&
              ball.portalCooldown <= 0) {
            final paired = game.obstacles[obs.pairedPortalIndex!];
            if (paired.isActive) {
              final pairedCenter = Offset(
                paired.x * w + paired.width * w / 2,
                paired.y * h + paired.height * h / 2,
              );
              ball.x = pairedCenter.dx;
              ball.y = pairedCenter.dy;
              ball.portalCooldown = 0.3;
            }
          }

        case ObstacleType.staticBlocker:
        case ObstacleType.movingBlocker:
          if (ballRect.overlaps(obsRect)) {
            if (ball.isFireball) {
              obs.hp--;
              if (obs.hp <= 0) obs.isActive = false;
              spawnParticles(ball.x, ball.y, NeonColors.red, count: 12);
            } else {
              _reflectBall(ball, obsRect);
            }
          }

        case ObstacleType.blackHole:
          final center = Offset(
            obs.x * w + obs.width * w / 2,
            obs.y * h + obs.height * h / 2,
          );
          final dist = (ballCenter - center).distance;
          if (dist < 100) {
            final pull = obs.pullStrength / (dist + 10);
            final dx = center.dx - ball.x;
            final dy = center.dy - ball.y;
            final len = sqrt(dx * dx + dy * dy);
            if (len > 0) {
              ball.vx += dx / len * pull;
              ball.vy += dy / len * pull;
            }
          }

        case ObstacleType.speedZone:
          if (ballRect.overlaps(obsRect)) {
            final factor = obs.speedMultiplier;
            ball.vx *= 1 + (factor - 1) * 0.02;
            ball.vy *= 1 + (factor - 1) * 0.02;
          }

        case ObstacleType.invisibleWall:
          if (ballRect.overlaps(obsRect)) {
            if (ball.isFireball) {
              obs.isActive = false;
              spawnParticles(ball.x, ball.y, NeonColors.green, count: 12);
            } else {
              _reflectBall(ball, obsRect);
            }
          }
      }
    }
  }

  void _reflectBall(PongBall ball, Rect obsRect) {
    final obsCenter = obsRect.center;
    final dx = ball.x - obsCenter.dx;
    final dy = ball.y - obsCenter.dy;

    if (dx.abs() / (obsRect.width / 2 + ball.radius) >
        dy.abs() / (obsRect.height / 2 + ball.radius)) {
      ball.vx = dx >= 0 ? ball.vx.abs() : -ball.vx.abs();
      ball.x = dx >= 0
          ? obsRect.right + ball.radius + 1
          : obsRect.left - ball.radius - 1;
    } else {
      ball.vy = dy >= 0 ? ball.vy.abs() : -ball.vy.abs();
      ball.y = dy >= 0
          ? obsRect.bottom + ball.radius + 1
          : obsRect.top - ball.radius - 1;
    }
  }
}
