import 'package:akillisletme/feature/games/color_pulse/color_pulse_view_model.dart';
import 'package:akillisletme/feature/games/color_pulse/painter/pulse_game_painter.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:akillisletme/product/widget/game/game_over_dialog.dart';
import 'package:akillisletme/product/widget/game/game_scaffold.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';

class ColorPulseView extends StatefulWidget {
  const ColorPulseView({super.key});

  @override
  State<ColorPulseView> createState() => _ColorPulseViewState();
}

class _ColorPulseViewState extends ColorPulseViewModel {
  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: 'COLOR PULSE',
      titleColor: NeonColors.pulseColor,
      score: game.score,
      onRestart: restartGame,
      onHome: () => Navigator.of(context).pop(),
      onPauseChanged: (paused) {
        if (paused) {
          pauseGame();
        } else {
          resumeGame();
        }
      },
      body: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // Game area.
            Positioned.fill(
              child: CustomPaint(
                painter: PulseGamePainter(
                  balls: game.balls,
                  ringColor: game.ringColor,
                  ringPulse: ringPulse,
                  lives: game.lives,
                ),
              ),
            ),

            // Combo flash.
            if (showComboFlash && game.combo >= 3)
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: NeonText(
                    'x${game.combo}',
                    color: NeonColors.yellow,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

            // Start message.
            if (!game.hasStarted)
              const Center(
                child: NeonText(
                  'TAP TO START',
                  color: NeonColors.pulseColor,
                  fontSize: 18,
                  enablePulse: true,
                ),
              ),

            // Game Over overlay.
            if (game.isGameOver)
              GameOverDialog(
                score: game.score,
                bestScore: locator.scoreService.pulseHighScore,
                isNewRecord:
                    game.score >= locator.scoreService.pulseHighScore,
                color: NeonColors.pulseColor,
                onRetry: restartGame,
                onHome: () => Navigator.of(context).pop(),
              ),
          ],
        ),
      ),
    );
  }
}
