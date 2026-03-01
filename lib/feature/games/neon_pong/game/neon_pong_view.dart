import 'package:akillisletme/feature/games/neon_pong/game/neon_pong_view_model.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_level_config.dart';
import 'package:akillisletme/feature/games/neon_pong/painter/pong_game_painter.dart';
import 'package:akillisletme/feature/games/neon_pong/widget/pong_active_effects_bar.dart';
import 'package:akillisletme/feature/games/neon_pong/widget/pong_boss_hp_bar.dart';
import 'package:akillisletme/feature/games/neon_pong/widget/pong_combo_display.dart';
import 'package:akillisletme/feature/games/neon_pong/widget/pong_level_complete_overlay.dart';
import 'package:akillisletme/feature/games/neon_pong/widget/pong_lives_bar.dart';
import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/init/language/locale_keys.g.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:akillisletme/product/widget/game/game_over_dialog.dart';
import 'package:akillisletme/product/widget/game/game_scaffold.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NeonPongView extends StatefulWidget {
  const NeonPongView({
    required this.mode,
    this.levelId,
    this.quickMatchDifficulty = QuickMatchDifficulty.medium,
    this.onBackToLevelSelect,
    this.onBackToModeSelect,
    super.key,
  });

  final PongMode mode;
  final int? levelId;
  final QuickMatchDifficulty quickMatchDifficulty;
  final VoidCallback? onBackToLevelSelect;
  final VoidCallback? onBackToModeSelect;

  @override
  State<NeonPongView> createState() => _NeonPongViewState();
}

class _NeonPongViewState extends NeonPongViewModel {
  String get _title {
    switch (widget.mode) {
      case PongMode.campaign:
        return game.levelConfig?.name ?? LocaleKeys.games_neonPong.tr();
      case PongMode.endless:
        return LocaleKeys.games_pongEndless.tr();
      case PongMode.quickMatch:
        return LocaleKeys.games_pongQuickMatch.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: _title,
      titleColor: NeonColors.pongColor,
      scoreWidget: _buildScoreWidget(),
      onRestart: restartGame,
      onHome: widget.onBackToModeSelect ?? () => Navigator.of(context).pop(),
      onPauseChanged: (paused) {
        if (paused) {
          pauseGame();
        } else {
          resumeGame();
        }
      },
      body: GestureDetector(
        onTap: onTap,
        onHorizontalDragUpdate: (details) {
          onPaddleDrag(details.delta.dx);
        },
        behavior: HitTestBehavior.opaque,
        child: LayoutBuilder(
          builder: (context, constraints) {
            gameSize = Size(constraints.maxWidth, constraints.maxHeight);

            return Transform.translate(
              offset: Offset(game.shakeX, game.shakeY),
              child: Stack(
                children: [
                  // Game area.
                  Positioned.fill(
                    child: CustomPaint(
                      painter: PongGamePainter(
                        state: game,
                        gameSize: gameSize,
                      ),
                    ),
                  ),

                  // Boss HP bar.
                  if (game.boss != null)
                    Positioned(
                      top: 4,
                      left: 16,
                      right: 16,
                      child: PongBossHpBar(boss: game.boss!),
                    ),

                  // Combo display.
                  if (game.combo.shouldShowText)
                    Positioned(
                      top: game.boss != null ? 28 : 8,
                      right: 8,
                      child: PongComboDisplay(combo: game.combo),
                    ),

                  // Active effects.
                  if (game.activeEffects.isNotEmpty)
                    Positioned(
                      bottom: 36,
                      left: 8,
                      right: 8,
                      child: PongActiveEffectsBar(effects: game.activeEffects),
                    ),

                  // Quick Match score.
                  if (widget.mode == PongMode.quickMatch)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 8,
                      child: Center(
                        child: Text(
                          '${game.playerScore} - ${game.aiScore}',
                          style: const TextStyle(
                            fontFamily: AppFonts.neonScore,
                            fontSize: 16,
                            color: NeonColors.yellow,
                          ),
                        ),
                      ),
                    ),

                  // Lives indicator.
                  if (widget.mode != PongMode.quickMatch)
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: PongLivesBar(
                        lives: game.lives,
                        maxLives: game.levelConfig?.lives ?? 3,
                      ),
                    ),

                  // Start message.
                  if (!game.hasStarted)
                    Center(
                      child: NeonText(
                        LocaleKeys.games_pongTapToStart.tr(),
                        color: NeonColors.pongColor,
                        fontSize: 18,
                        enablePulse: true,
                      ),
                    ),

                  // Level complete.
                  if (game.isLevelComplete)
                    PongLevelCompleteOverlay(
                      stars: game.earnedStars,
                      score: game.playerScore,
                      isBoss: game.levelConfig?.isBossLevel ?? false,
                      isQuickMatch: widget.mode == PongMode.quickMatch,
                      won: game.quickMatchWinner ?? true,
                      onNext: widget.mode == PongMode.campaign
                          ? widget.onBackToLevelSelect
                          : null,
                      onRetry: restartGame,
                      onLevelSelect: widget.onBackToLevelSelect,
                      onHome: widget.onBackToModeSelect,
                    ),

                  // Game Over.
                  if (game.isGameOver)
                    GameOverDialog(
                      score: game.playerScore,
                      bestScore: widget.mode == PongMode.endless
                          ? locator.scoreService.pongHighScore
                          : game.playerScore,
                      isNewRecord: widget.mode == PongMode.endless &&
                          game.playerScore >=
                              locator.scoreService.pongHighScore,
                      color: NeonColors.pongColor,
                      onRetry: restartGame,
                      onHome: widget.onBackToModeSelect ??
                          () => Navigator.of(context).pop(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget? _buildScoreWidget() {
    if (widget.mode == PongMode.quickMatch) return const SizedBox.shrink();
    return Text(
      game.playerScore.toString(),
      style: TextStyle(
        fontFamily: AppFonts.neonScore,
        fontSize: 12,
        color: NeonColors.yellow,
        shadows: [
          Shadow(
            color: NeonColors.glowOuter(NeonColors.yellow),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}
