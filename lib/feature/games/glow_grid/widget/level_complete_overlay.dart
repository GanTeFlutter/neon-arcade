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
class LevelCompleteOverlay extends StatelessWidget {
  const LevelCompleteOverlay({
    required this.stars,
    required this.moves,
    required this.color,
    required this.hasNext,
    this.onNext,
    this.onRetry,
    this.onHome,
    super.key,
  });

  final int stars;
  final int moves;
  final Color color;
  final bool hasNext;
  final VoidCallback? onNext;
  final VoidCallback? onRetry;
  final VoidCallback? onHome;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: ColoredBox(
        color: NeonColors.background.withValues(alpha: 0.75),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeonText(
                LocaleKeys.games_gridComplete.tr(),
                color: color,
                fontSize: 24,
                enablePulse: true,
              ),
              const SizedBox(height: 24),
              NeonStarRating(stars: stars, animate: true),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.games_gridMoves.tr(args: [moves.toString()]),
                style: const TextStyle(
                  fontFamily: AppFonts.neonScore,
                  fontSize: 12,
                  color: NeonColors.textDim,
                ),
              ),
              const SizedBox(height: 32),
              if (hasNext)
                SizedBox(
                  width: 220,
                  child: NeonButton(
                    label: LocaleKeys.games_gridNext.tr(),
                    color: color,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: onNext,
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: 220,
                child: NeonButton(
                  label: LocaleKeys.games_gridRetry.tr(),
                  color: NeonColors.yellow,
                  icon: Icons.refresh_rounded,
                  onPressed: onRetry,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 220,
                child: NeonButton(
                  label: LocaleKeys.games_gridLevelSelect.tr(),
                  color: NeonColors.textDim,
                  icon: Icons.grid_view_rounded,
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
