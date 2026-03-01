import 'dart:ui';

import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_button.dart';
import 'package:akillisletme/product/widget/neon/neon_star_rating.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';

/// Maze level tamamlama overlay'ı.
class MazeCompleteOverlay extends StatelessWidget {
  const MazeCompleteOverlay({
    required this.levelId,
    required this.stars,
    required this.timeLeft,
    required this.color,
    required this.hasNext,
    this.onNextLevel,
    this.onRetry,
    this.onLevelSelect,
    super.key,
  });

  final int levelId;
  final int stars;
  final double timeLeft;
  final Color color;
  final bool hasNext;
  final VoidCallback? onNextLevel;
  final VoidCallback? onRetry;
  final VoidCallback? onLevelSelect;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ColoredBox(
          color: NeonColors.background.withValues(alpha: 0.75),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NeonText(
                  'LEVEL $levelId',
                  color: color,
                  fontSize: 14,
                ),
                const SizedBox(height: 8),
                const NeonText(
                  'COMPLETE!',
                  color: NeonColors.green,
                  fontSize: 28,
                  enablePulse: true,
                ),
                const SizedBox(height: 24),
                NeonStarRating(stars: stars, animate: true),
                const SizedBox(height: 12),
                Text(
                  '${timeLeft.ceil()}s LEFT',
                  style: const TextStyle(
                    fontFamily: AppFonts.neonScore,
                    fontSize: 10,
                    color: NeonColors.textDim,
                  ),
                ),
                const SizedBox(height: 32),
                if (hasNext)
                  SizedBox(
                    width: 220,
                    child: NeonButton(
                      label: 'NEXT LEVEL',
                      color: color,
                      icon: Icons.arrow_forward_rounded,
                      onPressed: onNextLevel,
                    ),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 220,
                  child: NeonButton(
                    label: 'RETRY',
                    color: NeonColors.textDim,
                    icon: Icons.replay_rounded,
                    onPressed: onRetry,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 220,
                  child: NeonButton(
                    label: 'LEVELS',
                    color: NeonColors.textDim,
                    icon: Icons.grid_view_rounded,
                    onPressed: onLevelSelect,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
