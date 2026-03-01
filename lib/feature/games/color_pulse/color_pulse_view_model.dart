import 'dart:async';
import 'dart:math';

import 'package:akillisletme/feature/games/color_pulse/color_pulse_view.dart';
import 'package:akillisletme/feature/games/color_pulse/model/falling_ball.dart';
import 'package:akillisletme/feature/games/color_pulse/model/pulse_game_state.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Color Pulse game logic.
abstract class ColorPulseViewModel extends State<ColorPulseView>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _lastTick = Duration.zero;
  final _rng = Random();

  final PulseGameState game = PulseGameState();

  /// Ring pulse animation (0.6-1.0).
  double ringPulse = 1;
  double _pulseDir = -1;

  /// Whether to show the combo flash.
  bool showComboFlash = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _resetGame();
  }

  void _resetGame() {
    game
      ..balls.clear()
      ..ringColor = PulseGameState.gameColors[0]
      ..ringColorIndex = 0
      ..score = 0
      ..lives = 3
      ..combo = 0
      ..isGameOver = false
      ..hasStarted = false
      ..spawnTimer = 0
      ..ringTimer = 0
      ..spawnInterval = 1.8
      ..ringInterval = 2.0
      ..ballSpeed = 0.35;
    _lastTick = Duration.zero;
    ringPulse = 1;
    showComboFlash = false;
  }

  void startGame() {
    if (game.hasStarted) return;
    game.hasStarted = true;
    _ticker.start();
    setState(() {});
  }

  void restartGame() {
    _ticker.stop();
    _resetGame();
    setState(() {});
  }

  void pauseGame() {
    _ticker.stop();
  }

  void resumeGame() {
    if (game.hasStarted && !game.isGameOver) {
      _lastTick = Duration.zero;
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    if (game.isGameOver) return;

    final dt = _lastTick == Duration.zero
        ? 0.016
        : (elapsed - _lastTick).inMicroseconds / 1000000.0;
    _lastTick = elapsed;

    // Pulse animation.
    ringPulse += _pulseDir * dt * 0.6;
    if (ringPulse <= 0.6) {
      ringPulse = 0.6;
      _pulseDir = 1;
    } else if (ringPulse >= 1) {
      ringPulse = 1;
      _pulseDir = -1;
    }

    // Ring color change.
    game.ringTimer += dt;
    if (game.ringTimer >= game.ringInterval) {
      game.ringTimer = 0;
      game.ringColorIndex =
          (game.ringColorIndex + 1) % PulseGameState.gameColors.length;
      game.ringColor = PulseGameState.gameColors[game.ringColorIndex];
    }

    // Ball spawning.
    game.spawnTimer += dt;
    if (game.spawnTimer >= game.spawnInterval) {
      game.spawnTimer = 0;
      _spawnBall();
    }

    // Ball movement.
    for (final ball in game.balls) {
      ball.progress += ball.speed * dt;
    }

    // Check balls that reached the center (missed).
    final missed = game.balls.where((b) => b.reachedCenter).toList();
    for (final ball in missed) {
      game.balls.remove(ball);
      _missedBall();
    }

    setState(() {});
  }

  void _spawnBall() {
    // From one of 4 directions (0, pi/2, pi, 3pi/2) + slight offset.
    final baseAngle = (_rng.nextInt(4)) * pi / 2;
    final jitter = (_rng.nextDouble() - 0.5) * 0.3;
    final angle = baseAngle + jitter;

    // Color: 60% chance of matching the ring color.
    final Color color;
    if (_rng.nextDouble() < 0.6) {
      color = game.ringColor;
    } else {
      final others = PulseGameState.gameColors
          .where((c) => c != game.ringColor)
          .toList();
      color = others[_rng.nextInt(others.length)];
    }

    game.balls.add(
      FallingBall(
        color: color,
        angle: angle,
        speed: game.ballSpeed,
      ),
    );
  }

  /// Tap on screen — hit the nearest ball.
  void onTap() {
    if (game.isGameOver) return;
    if (!game.hasStarted) {
      startGame();
      return;
    }

    if (game.balls.isEmpty) return;

    // Find the most advanced (closest to center) ball.
    FallingBall? closest;
    for (final ball in game.balls) {
      if (closest == null || ball.progress > closest.progress) {
        closest = ball;
      }
    }

    if (closest == null) return;

    // Color match check.
    if (closest.color == game.ringColor) {
      // Correct match!
      game.balls.remove(closest);
      game.combo++;
      final multiplier = min(game.combo, 5);
      game.score += multiplier;

      if (game.combo >= 3) {
        _showCombo();
      }

      unawaited(locator.audioService.playBlip());
      unawaited(locator.vibrationService.light());

      // Difficulty increase (every 10 points).
      if (game.score % 10 == 0) {
        game.ballSpeed = min(game.ballSpeed * 1.1, 0.9);
        game.spawnInterval = max(game.spawnInterval * 0.92, 0.6);
        game.ringInterval = max(game.ringInterval * 0.95, 0.8);
      }
    } else {
      // Wrong match — lose a life.
      game.balls.remove(closest);
      game.combo = 0;
      game.lives--;
      unawaited(locator.audioService.playBuzz());
      unawaited(locator.vibrationService.heavy());

      if (game.lives <= 0) {
        _gameOver();
      }
    }

    setState(() {});
  }

  void _missedBall() {
    game.combo = 0;
    game.lives--;
    unawaited(locator.audioService.playBuzz());
    unawaited(locator.vibrationService.medium());

    if (game.lives <= 0) {
      _gameOver();
    }
  }

  void _showCombo() {
    showComboFlash = true;
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => showComboFlash = false);
    });
  }

  void _gameOver() {
    game.isGameOver = true;
    _ticker.stop();
    unawaited(locator.scoreService.updatePulseHighScore(game.score));
    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
