import 'package:akillisletme/feature/games/neon_stack/neon_stack_view_model.dart';
import 'package:akillisletme/feature/games/neon_stack/widget/falling_piece.dart';
import 'package:akillisletme/feature/games/neon_stack/widget/perfect_flash.dart';
import 'package:akillisletme/feature/games/neon_stack/widget/stack_block_widget.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:akillisletme/product/widget/game/game_over_dialog.dart';
import 'package:akillisletme/product/widget/game/game_scaffold.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';

class NeonStackView extends StatefulWidget {
  const NeonStackView({super.key});

  @override
  State<NeonStackView> createState() => _NeonStackViewState();
}

class _NeonStackViewState extends NeonStackViewModel {
  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: 'NEON STACK',
      titleColor: NeonColors.stackColor,
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final blockH = h * 0.04; // Height of each block.

            // Camera offset: the scene scrolls as blocks stack higher.
            final visibleBlocks = (h / blockH).floor();
            final cameraOffset =
                game.blocks.length > visibleBlocks - 3
                    ? (game.blocks.length - (visibleBlocks - 3)) * blockH
                    : 0.0;

            return Stack(
              children: [
                // Stacked blocks.
                for (var i = 0; i < game.blocks.length; i++)
                  StackBlockWidget(
                    color: game.blocks[i].color,
                    width: game.blocks[i].width * w,
                    height: blockH,
                    left: game.blocks[i].left * w,
                    bottom: i * blockH - cameraOffset,
                    isPerfect: game.blocks[i].isPerfect,
                  ),

                // Moving block (if game has started and is not over).
                if (game.hasStarted && !game.isGameOver)
                  StackBlockWidget(
                    color: NeonColors.textBright,
                    width: game.movingWidth * w,
                    height: blockH,
                    left: game.movingX * w,
                    bottom: game.blocks.length * blockH - cameraOffset,
                  ),

                // Falling pieces.
                for (final piece in fallingPieces)
                  FallingPiece(
                    key: ValueKey(piece.hashCode),
                    color: piece.color,
                    width: piece.width * w,
                    height: blockH,
                    left: piece.left * w,
                    bottom:
                        (game.blocks.length - 1) * blockH - cameraOffset,
                  ),

                // PERFECT flash.
                if (showPerfect)
                  Positioned(
                    top: h * 0.3,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: PerfectFlash(
                        key: ValueKey(game.score),
                        combo: perfectCombo,
                      ),
                    ),
                  ),

                // Start message.
                if (!game.hasStarted)
                  const Center(
                    child: NeonText(
                      'TAP TO START',
                      color: NeonColors.stackColor,
                      fontSize: 18,
                      enablePulse: true,
                    ),
                  ),

                // Game Over overlay.
                if (game.isGameOver)
                  GameOverDialog(
                    score: game.score,
                    bestScore: locator.scoreService.stackHighScore,
                    isNewRecord:
                        game.score >= locator.scoreService.stackHighScore,
                    color: NeonColors.stackColor,
                    onRetry: restartGame,
                    onHome: () => Navigator.of(context).pop(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
