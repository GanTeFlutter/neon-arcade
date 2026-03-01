import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_card.dart';
import 'package:flutter/material.dart';

/// Game card in the main menu.
/// Displays icon, name, description and high score.
class GameCard extends StatelessWidget {
  const GameCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    this.bestScore,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final int? bestScore;

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      color: color,
      onTap: onTap,
      child: Row(
        children: [
          // Game icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          // Name + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFonts.neonDisplay,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: NeonColors.glowOuter(color),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: AppFonts.body,
                    fontSize: 11,
                    color: NeonColors.textDim,
                  ),
                ),
              ],
            ),
          ),
          // Score
          if (bestScore != null && bestScore! > 0)
            Column(
              children: [
                Text(
                  bestScore.toString(),
                  style: TextStyle(
                    fontFamily: AppFonts.neonScore,
                    fontSize: 10,
                    color: color,
                    shadows: [
                      Shadow(
                        color: NeonColors.glowOuter(color),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'BEST',
                  style: TextStyle(
                    fontFamily: AppFonts.body,
                    fontSize: 8,
                    color: NeonColors.textDim,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
