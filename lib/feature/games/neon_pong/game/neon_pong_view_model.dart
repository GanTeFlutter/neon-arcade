// ignore_for_file: cascade_invocations, for readability in game loop

import 'dart:async';
import 'dart:math';

import 'package:akillisletme/feature/games/neon_pong/campaign/data/pong_boss_data.dart';
import 'package:akillisletme/feature/games/neon_pong/campaign/data/pong_levels.dart';
import 'package:akillisletme/feature/games/neon_pong/game/mixin/pong_ai_mixin.dart';
import 'package:akillisletme/feature/games/neon_pong/game/mixin/pong_ball_physics_mixin.dart';
import 'package:akillisletme/feature/games/neon_pong/game/mixin/pong_boss_mixin.dart';
import 'package:akillisletme/feature/games/neon_pong/game/mixin/pong_combo_mixin.dart';
import 'package:akillisletme/feature/games/neon_pong/game/mixin/pong_effects_mixin.dart';
import 'package:akillisletme/feature/games/neon_pong/game/mixin/pong_obstacle_mixin.dart';
import 'package:akillisletme/feature/games/neon_pong/game/mixin/pong_particle_mixin.dart';
import 'package:akillisletme/feature/games/neon_pong/game/mixin/pong_power_up_mixin.dart';
import 'package:akillisletme/feature/games/neon_pong/game/neon_pong_view.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_game_state.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_level_config.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Neon Pong game logic — supports all modes.
abstract class NeonPongViewModel extends State<NeonPongView>
    with
        SingleTickerProviderStateMixin,
        PongBallPhysicsMixin,
        PongAiMixin,
        PongPowerUpMixin,
        PongComboMixin,
        PongParticleMixin,
        PongEffectsMixin,
        PongObstacleMixin,
        PongBossMixin {
  late Ticker _ticker;
  Duration _lastTick = Duration.zero;

  @override
  final Random rng = Random();

  @override
  final PongGameState game = PongGameState();

  @override
  Size gameSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _setupGame();
  }

  void _setupGame() {
    game.mode = widget.mode;

    switch (widget.mode) {
      case PongMode.campaign:
        if (widget.levelId != null) {
          final config = PongLevels.getLevel(widget.levelId!);
          game.levelConfig = config;
          game.aiPaddle.baseWidth = config.isBossLevel
              ? (PongBossData.fromWorldIndex(config.worldIndex).paddleWidth)
              : 0.2;
          game.aiPaddle.width = game.aiPaddle.baseWidth;
        }

      case PongMode.endless:
        game.levelConfig = null;
        game.lives = 3;

      case PongMode.quickMatch:
        game.quickMatchDifficulty = widget.quickMatchDifficulty;
        game.levelConfig = _quickMatchConfig(widget.quickMatchDifficulty);
        game.lives = 99;
    }

    _resetGame();
  }

  PongLevelConfig _quickMatchConfig(QuickMatchDifficulty difficulty) {
    switch (difficulty) {
      case QuickMatchDifficulty.easy:
        return const PongLevelConfig(
          id: 0, worldIndex: 0, name: 'Quick Easy',
          aiSpeed: 0.45, aiErrorRate: 0.45, aiReactionDelay: 0.3,
          ballSpeed: 260, lives: 99, requiredScore: 11,
        );
      case QuickMatchDifficulty.medium:
        return const PongLevelConfig(
          id: 0, worldIndex: 0, name: 'Quick Medium',
          aiSpeed: 0.6, aiErrorRate: 0.25, aiReactionDelay: 0.18,
          ballSpeed: 300, lives: 99, requiredScore: 11,
        );
      case QuickMatchDifficulty.hard:
        return const PongLevelConfig(
          id: 0, worldIndex: 0, name: 'Quick Hard',
          aiSpeed: 0.78, aiErrorRate: 0.12, aiReactionDelay: 0.1,
          ballSpeed: 360, lives: 99, requiredScore: 11,
        );
    }
  }

  void _resetGame() {
    game.reset();
    resetAi();

    // Load obstacles (campaign).
    if (widget.mode == PongMode.campaign && game.levelConfig != null) {
      for (final oc in game.levelConfig!.obstacles) {
        game.obstacles.add(oc.toObstacle());
      }
      if (game.levelConfig!.isBossLevel) {
        game.boss = PongBossData.fromWorldIndex(game.levelConfig!.worldIndex);
      }
    }

    _lastTick = Duration.zero;
  }

  void startGame() {
    if (game.hasStarted) return;
    game.hasStarted = true;
    spawnBall();
    _ticker.start();
    setState(() {});
  }

  void restartGame() {
    _ticker.stop();
    _resetGame();
    setState(() {});
  }

  void pauseGame() => _ticker.stop();

  void resumeGame() {
    if (game.hasStarted && !game.isGameOver && !game.isLevelComplete) {
      _lastTick = Duration.zero;
      _ticker.start();
    }
  }

  void onPaddleDrag(double deltaX) {
    if (gameSize.width == 0 || game.playerPaddle.isFrozen) return;
    game.playerPaddle.x += deltaX / gameSize.width;
    game.playerPaddle.x = game.playerPaddle.x.clamp(
      game.playerPaddle.width / 2,
      1 - game.playerPaddle.width / 2,
    );

    // Magnetic ball should move together with the paddle.
    if (game.playerPaddle.isMagnetic &&
        game.playerPaddle.magnetBallRelativeX != null) {
      for (final ball in game.balls) {
        if (ball.vx == 0 && ball.vy == 0) {
          final w = gameSize.width;
          final paddleLeft =
              game.playerPaddle.x * w - (game.playerPaddle.width * w / 2);
          ball.x = paddleLeft +
              game.playerPaddle.magnetBallRelativeX! *
                  game.playerPaddle.width *
                  w;
        }
      }
    }
  }

  void onTap() {
    if (!game.hasStarted) {
      startGame();
      return;
    }
    // Release magnetic ball.
    if (game.playerPaddle.isMagnetic &&
        game.playerPaddle.magnetBallRelativeX != null) {
      releaseMagneticBall();
    }
  }

  void _onTick(Duration elapsed) {
    if (game.isGameOver || game.isLevelComplete || gameSize == Size.zero) {
      return;
    }

    var dt = _lastTick == Duration.zero
        ? 0.016
        : (elapsed - _lastTick).inMicroseconds / 1000000.0;
    _lastTick = elapsed;

    // Slow motion.
    dt *= game.slowMotionFactor;

    // Effects.
    updateEffects(dt);

    // AI movement.
    if (game.boss == null) {
      updateAi(dt);
    } else {
      updateBossMovement(dt);
    }

    // Power-ups.
    updatePowerUps(dt);

    // Update obstacles (moving ones).
    updateObstacles(dt);

    // Ball physics.
    _processPhysics(dt);

    // Particles.
    updateParticles(dt);

    // Boss attack.
    if (game.boss != null) {
      updateBossAttack(dt);
      updateBossProjectiles(dt);
    }

    // Player lasers vs boss.
    checkLaserBossHit();

    setState(() {});
  }

  void _processPhysics(double dt) {
    final result = updateBalls(dt);
    final w = gameSize.width;
    final h = gameSize.height;

    // Paddle collision checks.
    for (final ball in game.balls) {
      // Player paddle.
      if (checkPaddleCollision(ball, game.playerPaddle, dt)) {
        incrementCombo();

        // In Quick Match, paddle hits don't give score — score only
        // increases when the ball goes past the opponent's side.
        if (game.mode != PongMode.quickMatch) {
          final points = calculateScore(1);
          game.playerScore += points;
        }

        unawaited(locator.audioService.playBlip());
        unawaited(locator.vibrationService.light());

        // Combo sound escalation.
        if (game.combo.streak >= 7) {
          unawaited(locator.audioService.playPerfect());
        } else if (game.combo.streak >= 3) {
          unawaited(locator.audioService.playChime());
        }

        spawnParticles(ball.x, ball.y, NeonColors.cyan, count: 6);
      }

      // AI paddle or boss paddle.
      if (game.boss != null) {
        checkBossPaddleHit(ball, dt);
      } else {
        if (checkPaddleCollision(ball, game.aiPaddle, dt, isPlayer: false)) {
          // AI bounce - no score, just reflection.
        }
      }

      // Obstacle interactions.
      checkObstacleCollision(ball, w, h);
    }

    // Player ball loss.
    for (final ball in result.playerLost) {
      game.balls.remove(ball);

      if (game.mode != PongMode.quickMatch) {
        game.lives--;
        resetCombo();

        unawaited(locator.audioService.playBuzz());
        unawaited(locator.vibrationService.heavy());
        triggerShake();
        triggerChromaticAberration();

        checkLastLifeSlowMotion();

        if (game.lives <= 0) {
          _gameOver();
          return;
        }
      } else {
        // Quick match: AI scores a point.
        game.aiScore++;
        unawaited(locator.audioService.playBuzz());
        unawaited(locator.vibrationService.medium());

        if (game.aiScore >= PongGameState.quickMatchWinScore) {
          game.quickMatchWinner = false;
          _gameOver();
          return;
        }
      }

      if (game.balls.isEmpty) spawnBall();
    }

    // AI ball loss (ball went past the top).
    for (final ball in result.aiLost) {
      game.balls.remove(ball);

      if (game.boss != null) {
        game.boss!.takeDamage(1);
        unawaited(locator.audioService.playBlip());
        unawaited(locator.vibrationService.light());
        triggerShake(duration: 0.15);

        if (game.boss!.isDead) {
          _bossDefeated();
          return;
        }
      } else if (game.mode == PongMode.quickMatch) {
        game.playerScore++;
        unawaited(locator.audioService.playChime());
        unawaited(locator.vibrationService.medium());

        if (game.playerScore >= PongGameState.quickMatchWinScore) {
          game.quickMatchWinner = true;
          _levelComplete();
          return;
        }
      }

      if (game.balls.isEmpty) spawnBall();
    }

    // Campaign: requiredScore check.
    if (game.mode == PongMode.campaign &&
        game.levelConfig != null &&
        !game.levelConfig!.isBossLevel &&
        game.playerScore >= game.levelConfig!.requiredScore) {
      _levelComplete();
    }
  }

  @override
  void onBossDefeated() => _bossDefeated();

  @override
  void onGameOver() => _gameOver();

  void _bossDefeated() {
    game.isLevelComplete = true;
    game.earnedStars = game.levelConfig?.calculateStars(
          game.playerScore,
          livesRemaining: game.lives,
        ) ??
        3;
    _ticker.stop();

    if (game.levelConfig != null) {
      unawaited(locator.scoreService.updatePongProgress(
        game.levelConfig!.id, game.earnedStars,
      ));
    }
    unawaited(locator.audioService.playPerfect());
    unawaited(locator.vibrationService.heavy());
  }

  void _levelComplete() {
    game.isLevelComplete = true;
    game.earnedStars = game.levelConfig?.calculateStars(game.playerScore) ?? 3;
    _ticker.stop();

    if (game.levelConfig != null && widget.mode == PongMode.campaign) {
      unawaited(locator.scoreService.updatePongProgress(
        game.levelConfig!.id, game.earnedStars,
      ));
    }

    unawaited(locator.audioService.playSynth());
    unawaited(locator.vibrationService.medium());
  }

  void _gameOver() {
    game.isGameOver = true;
    _ticker.stop();

    if (game.mode == PongMode.endless) {
      unawaited(locator.scoreService.updatePongHighScore(game.playerScore));
    }

    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
