import 'dart:ui';

import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_button.dart';
import 'package:akillisletme/product/widget/neon/neon_star_rating.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';

/// Common game over screen.
/// Blur background + score + high score + stars + retry/main menu.
class GameOverDialog extends StatelessWidget {
  const GameOverDialog({
    required this.score,
    required this.bestScore,
    this.isNewRecord = false,
    this.stars,
    this.onRetry,
    this.onHome,
    this.color,
    super.key,
  });

  final int score;
  final int bestScore;
  final bool isNewRecord;

  /// Only for level-based games (range 0-3).
  final int? stars;
  final VoidCallback? onRetry;
  final VoidCallback? onHome;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final accentColor = color ?? NeonColors.red;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: ColoredBox(
        color: NeonColors.background.withValues(alpha: 0.75),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const NeonText(
                'GAME OVER',
                color: NeonColors.red,
                fontSize: 28,
                enablePulse: true,
              ),
              const SizedBox(height: 32),

              // Score
              Text(
                score.toString(),
                style: TextStyle(
                  fontFamily: AppFonts.neonScore,
                  fontSize: 32,
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
              const SizedBox(height: 8),

              // High score
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'BEST: $bestScore',
                    style: const TextStyle(
                      fontFamily: AppFonts.neonScore,
                      fontSize: 10,
                      color: NeonColors.textDim,
                    ),
                  ),
                  if (isNewRecord) ...[
                    const SizedBox(width: 8),
                    const NeonText(
                      'NEW!',
                      color: NeonColors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),

              // Stars (for level-based games)
              if (stars != null) ...[
                NeonStarRating(stars: stars!, animate: true),
                const SizedBox(height: 24),
              ],

              // Buttons
              const SizedBox(height: 16),
              SizedBox(
                width: 220,
                child: NeonButton(
                  label: 'TEKRAR OYNA',
                  color: accentColor,
                  icon: Icons.replay_rounded,
                  onPressed: onRetry,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 220,
                child: NeonButton(
                  label: 'ANA MENU',
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
