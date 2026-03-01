import 'dart:math';
import 'dart:ui';

import 'package:akillisletme/feature/games/neon_pong/model/pong_game_state.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_particle.dart';

/// Spark particle management.
mixin PongParticleMixin {
  PongGameState get game;
  Random get rng;

  /// Update particles.
  void updateParticles(double dt) {
    for (final p in game.particles) {
      p.update(dt);
    }
    game.particles.removeWhere((p) => p.isDead);
  }

  /// Spawn sparks at a specific point.
  void spawnParticles(double x, double y, Color color, {int count = 8}) {
    for (var i = 0; i < count; i++) {
      if (game.particles.length >= PongGameState.maxParticles) break;
      final angle = rng.nextDouble() * 2 * pi;
      final speed = 50 + rng.nextDouble() * 150;
      game.particles.add(PongParticle(
        x: x,
        y: y,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        color: color,
        lifetime: 0.3 + rng.nextDouble() * 0.4,
        radius: 1.5 + rng.nextDouble() * 2,
      ));
    }
  }
}
