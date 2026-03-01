import 'dart:math';

import 'package:akillisletme/feature/games/neon_pong/model/pong_game_state.dart';

/// Visual effects: screen shake, slow motion, chromatic aberration.
mixin PongEffectsMixin {
  PongGameState get game;
  Random get rng;

  void updateEffects(double dt) {
    // Screen shake.
    if (game.shakeTimer > 0) {
      game.shakeTimer -= dt;
      game.shakeX = (rng.nextDouble() - 0.5) * 6;
      game.shakeY = (rng.nextDouble() - 0.5) * 6;
    } else {
      game.shakeX = 0;
      game.shakeY = 0;
    }

    // Slow motion.
    if (game.slowMotionTimer > 0) {
      game.slowMotionTimer -= dt;
      if (game.slowMotionTimer <= 0) {
        game.slowMotionFactor = 1.0;
      }
    }

    // Chromatic aberration decay.
    if (game.chromaticAberration > 0) {
      game.chromaticAberration = (game.chromaticAberration - dt * 3).clamp(0.0, 5.0);
    }
  }

  /// Trigger screen shake.
  void triggerShake({double duration = 0.2}) {
    game.shakeTimer = duration;
  }

  /// Trigger slow motion.
  void triggerSlowMotion({double duration = 1.5, double factor = 0.3}) {
    game.slowMotionFactor = factor;
    game.slowMotionTimer = duration;
  }

  /// Trigger chromatic aberration.
  void triggerChromaticAberration({double intensity = 3}) {
    game.chromaticAberration = intensity;
  }

  /// Last life slow motion.
  void checkLastLifeSlowMotion() {
    if (game.lives == 1 && !game.lastLifeSlowTriggered) {
      game.lastLifeSlowTriggered = true;
      triggerSlowMotion(duration: 1.5, factor: 0.3);
      triggerChromaticAberration(intensity: 4);
    }
  }
}
