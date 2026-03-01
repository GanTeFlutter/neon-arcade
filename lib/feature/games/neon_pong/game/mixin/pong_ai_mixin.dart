// ignore_for_file: cascade_invocations
import 'dart:math';
import 'dart:ui';

import 'package:akillisletme/feature/games/neon_pong/model/pong_game_state.dart';

/// AI paddle control logic.
mixin PongAiMixin {
  PongGameState get game;
  Size get gameSize;
  Random get rng;

  double _aiTargetX = 0.5;
  double _aiReactionTimer = 0;
  double _aiErrorOffset = 0;

  void resetAi() {
    _aiTargetX = 0.5;
    _aiReactionTimer = 0;
    _aiErrorOffset = 0;
  }

  void updateAi(double dt) {
    final paddle = game.aiPaddle;
    if (paddle.isFrozen) return;

    final config = game.levelConfig;
    var aiSpeed = config?.aiSpeed ?? 0.6;
    var errorRate = config?.aiErrorRate ?? 0.3;
    var reactionDelay = config?.aiReactionDelay ?? 0.2;

    // Slow effect.
    if (paddle.isSlowed) {
      aiSpeed *= 0.5;
    }

    // Blind effect: high error rate.
    if (paddle.isBlind) {
      errorRate = 0.8;
      reactionDelay = 0.5;
    }

    // Shrink effect: paddle is small.
    if (paddle.isShrunk) {
      paddle.width = paddle.baseWidth * 0.5;
    }

    // Reaction delay.
    _aiReactionTimer += dt;
    if (_aiReactionTimer >= reactionDelay) {
      _aiReactionTimer = 0;
      _updateAiTarget(errorRate);
    }

    // Move towards target.
    final diff = _aiTargetX - paddle.x;
    final maxMove = aiSpeed * dt;
    if (diff.abs() > maxMove) {
      paddle.x += maxMove * diff.sign;
    } else {
      paddle.x = _aiTargetX;
    }

    paddle.x = paddle.x.clamp(
      paddle.width / 2,
      1 - paddle.width / 2,
    );
  }

  void _updateAiTarget(double errorRate) {
    // Find the nearest ball (heading towards AI side).
    final balls = game.balls.where((b) => b.vy < 0).toList();
    if (balls.isEmpty) {
      // Stay in the center if there is no ball.
      _aiTargetX = 0.5;
      return;
    }

    // Select the nearest (highest Y) ball.
    balls.sort((a, b) => a.y.compareTo(b.y));
    final target = balls.first;

    // Prediction: X position when the ball reaches the AI paddle level.
    final w = gameSize.width;
    final aiPaddleY = game.aiPaddle.y + 16;
    final timeToReach = (target.y - aiPaddleY) / (-target.vy);
    var predictedX = target.x + target.vx * timeToReach;

    // Wall reflections.
    while (predictedX < 0 || predictedX > w) {
      if (predictedX < 0) predictedX = -predictedX;
      if (predictedX > w) predictedX = 2 * w - predictedX;
    }

    // Error rate: random deviation.
    _aiErrorOffset = (rng.nextDouble() - 0.5) * errorRate * 0.4;
    _aiTargetX = (predictedX / w + _aiErrorOffset).clamp(0.0, 1.0);
  }
}
