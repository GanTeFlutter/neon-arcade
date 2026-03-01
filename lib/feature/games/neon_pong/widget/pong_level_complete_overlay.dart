import 'dart:ui';

import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/init/language/locale_keys.g.dart';
import 'package:akillisletme/product/widget/neon/neon_button.dart';
import 'package:akillisletme/product/widget/neon/neon_star_rating.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Level completion overlay.
class PongLevelCompleteOverlay extends StatelessWidget {
  const PongLevelCompleteOverlay({
    required this.stars,
    required this.score,
    this.isBoss = false,
    this.isQuickMatch = false,
    this.won = true,
    this.onNext,
    this.onRetry,
    this.onLevelSelect,
    this.onHome,
    super.key,
  });

  final int stars;
  final int score;
  final bool isBoss;
  final bool isQuickMatch;
  final bool won;
  final VoidCallback? onNext;
  final VoidCallback? onRetry;
  final VoidCallback? onLevelSelect;
  final VoidCallback? onHome;

  @override
  Widget build(BuildContext context) {
    final titleText = isQuickMatch
        ? (won ? LocaleKeys.games_pongYouWon.tr() : LocaleKeys.games_pongYouLost.tr())
        : (isBoss ? LocaleKeys.games_pongBossDefeated.tr() : LocaleKeys.games_pongLevelComplete.tr());
    final titleColor = isQuickMatch
        ? (won ? NeonColors.green : NeonColors.red)
        : NeonColors.green;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: ColoredBox(
        color: NeonColors.background.withValues(alpha: 0.75),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeonText(
                titleText,
                color: titleColor,
                fontSize: 24,
                enablePulse: true,
              ),
              const SizedBox(height: 24),

              // Score.
              Text(
                score.toString(),
                style: TextStyle(
                  fontFamily: AppFonts.neonScore,
                  fontSize: 28,
                  color: NeonColors.yellow,
                  shadows: [
                    Shadow(
                      color: NeonColors.glowInner(NeonColors.yellow),
                      blurRadius: 6,
                    ),
                    Shadow(
                      color: NeonColors.glowOuter(NeonColors.yellow),
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Stars.
              if (!isQuickMatch) ...[
                NeonStarRating(stars: stars, animate: true),
                const SizedBox(height: 24),
              ],

              // Buttons.
              const SizedBox(height: 12),
              if (onNext != null)
                SizedBox(
                  width: 220,
                  child: NeonButton(
                    label: LocaleKeys.games_pongLevelSelect.tr(),
                    color: NeonColors.cyan,
                    icon: Icons.grid_view_rounded,
                    onPressed: onNext,
                  ),
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: 220,
                child: NeonButton(
                  label: LocaleKeys.games_pongRetry.tr(),
                  color: NeonColors.pongColor,
                  icon: Icons.replay_rounded,
                  onPressed: onRetry,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 220,
                child: NeonButton(
                  label: LocaleKeys.games_pongMainMenu.tr(),
                  color: NeonColors.textDim,
                  icon: Icons.home_rounded,
                  onPressed: onHome,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
