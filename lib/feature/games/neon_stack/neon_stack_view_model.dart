import 'dart:async';
import 'dart:math';

import 'package:akillisletme/feature/games/neon_stack/model/stack_game_state.dart';
import 'package:akillisletme/feature/games/neon_stack/neon_stack_view.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Neon Stack game logic.
/// 60fps game loop, block movement, alignment, scoring.
abstract class NeonStackViewModel extends State<NeonStackView>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _lastTick = Duration.zero;

  final StackGameState game = StackGameState();

  /// Falling piece info (for animation).
  final List<FallingInfo> fallingPieces = [];

  /// PERFECT flash visibility.
  bool showPerfect = false;
  int perfectCombo = 0;

  /// Block color palette (cyan -> magenta gradient).
  static const _colors = [
    NeonColors.cyan,
    Color(0xFF00DDFF),
    Color(0xFF44BBFF),
    Color(0xFF8888FF),
    Color(0xFFBB55FF),
    NeonColors.magenta,
  ];

  Color _colorForIndex(int index) {
    return _colors[index % _colors.length];
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _resetGame();
  }

  void _resetGame() {
    game
      ..blocks.clear()
      ..movingX = 0
      ..movingWidth = 0.4
      ..direction = 1
      ..speed = 0.6
      ..score = 0
      ..combo = 0
      ..isGameOver = false
      ..hasStarted = false;
    fallingPieces.clear();
    showPerfect = false;
    _lastTick = Duration.zero;

    // Initial block (on the ground, centered).
    game.blocks.add(
      StackBlock(
        left: 0.3,
        width: 0.4,
        color: _colorForIndex(0),
      ),
    );
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

    // Block movement.
    game.movingX += game.speed * game.direction * dt;

    // Bounce off boundaries.
    final maxX = 1.0 - game.movingWidth;
    if (game.movingX >= maxX) {
      game.movingX = maxX;
      game.direction = -1;
    } else if (game.movingX <= 0) {
      game.movingX = 0;
      game.direction = 1;
    }

    setState(() {});
  }

  /// User tapped the screen — drop the block.
  void onTap() {
    if (game.isGameOver) return;
    if (!game.hasStarted) {
      startGame();
      return;
    }
    _dropBlock();
  }

  void _dropBlock() {
    final topBlock = game.blocks.last;
    final mLeft = game.movingX;
    final mRight = mLeft + game.movingWidth;
    final tLeft = topBlock.left;
    final tRight = topBlock.right;

    // Calculate overlap.
    final overlapLeft = max(mLeft, tLeft);
    final overlapRight = min(mRight, tRight);
    final overlapWidth = overlapRight - overlapLeft;

    if (overlapWidth <= 0) {
      // Completely missed — game over.
      _gameOver();
      return;
    }

    // PERFECT check.
    final leftDiff = (mLeft - tLeft).abs();
    final rightDiff = (mRight - tRight).abs();
    final isPerfect = leftDiff < StackGameState.perfectTolerance &&
        rightDiff < StackGameState.perfectTolerance;

    double finalLeft;
    double finalWidth;

    if (isPerfect) {
      // PERFECT: block does not shrink.
      finalLeft = topBlock.left;
      finalWidth = topBlock.width;
      game.combo++;

      // 3+ combo = width expansion.
      if (game.combo >= 3) {
        final bonus =
            StackGameState.comboWidthBonus * (game.combo - 2);
        finalWidth = min(finalWidth + bonus, 0.9);
        finalLeft = max(0, finalLeft - bonus / 2);
      }

      _showPerfectFlash();
      unawaited(locator.audioService.playPerfect());
      unawaited(locator.vibrationService.medium());
    } else {
      // Normal: only the overlapping part remains.
      finalLeft = overlapLeft;
      finalWidth = overlapWidth;
      game.combo = 0;

      // Create falling piece.
      _addFallingPiece(mLeft, mRight, tLeft, tRight, overlapLeft, overlapRight);

      unawaited(locator.audioService.playBlip());
      unawaited(locator.vibrationService.light());
    }

    final blockColor = _colorForIndex(game.blocks.length);
    game.blocks.add(
      StackBlock(
        left: finalLeft,
        width: finalWidth,
        color: blockColor,
        isPerfect: isPerfect,
      ),
    );

    // Update score.
    game.score += isPerfect ? 2 + game.combo : 1;

    // Speed increase (every 10 blocks).
    if (game.blocks.length % 10 == 0) {
      game.speed = min(
        game.speed * (1 + StackGameState.speedIncrement),
        StackGameState.maxSpeed,
      );
    }

    // New moving block initial width.
    game.movingWidth = finalWidth;

    // Reset direction (start from a random edge).
    game.direction = 1;
    game.movingX = 0;

    setState(() {});
  }

  void _addFallingPiece(
    double mLeft,
    double mRight,
    double tLeft,
    double tRight,
    double overlapLeft,
    double overlapRight,
  ) {
    // Left overhanging piece.
    if (mLeft < tLeft) {
      fallingPieces.add(
        FallingInfo(
          left: mLeft,
          width: overlapLeft - mLeft,
          color: _colorForIndex(game.blocks.length),
        ),
      );
    }
    // Right overhanging piece.
    if (mRight > tRight) {
      fallingPieces.add(
        FallingInfo(
          left: overlapRight,
          width: mRight - overlapRight,
          color: _colorForIndex(game.blocks.length),
        ),
      );
    }

    // Clean up old pieces (max 4).
    if (fallingPieces.length > 4) {
      fallingPieces.removeRange(0, fallingPieces.length - 4);
    }
  }

  void _showPerfectFlash() {
    showPerfect = true;
    perfectCombo = game.combo;
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => showPerfect = false);
      }
    });
  }

  void _gameOver() {
    game.isGameOver = true;
    _ticker.stop();
    unawaited(locator.audioService.playBuzz());
    unawaited(locator.vibrationService.heavy());

    // Save score.
    unawaited(locator.scoreService.updateStackHighScore(game.score));

    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

/// Falling piece data.
class FallingInfo {
  const FallingInfo({
    required this.left,
    required this.width,
    required this.color,
  });

  final double left;
  final double width;
  final Color color;
}
