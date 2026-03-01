import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// A single tile on the level selection screen.
class LevelTile extends StatelessWidget {
  const LevelTile({
    required this.levelId,
    required this.color,
    required this.stars,
    required this.isUnlocked,
    required this.onTap,
    super.key,
  });

  final int levelId;
  final Color color;

  /// 0=not yet solved, 1-3=stars.
  final int stars;
  final bool isUnlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked
              ? (stars > 0
                  ? color.withValues(alpha: 0.12)
                  : NeonColors.surfaceDark)
              : NeonColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isUnlocked
                ? color.withValues(alpha: stars > 0 ? 0.6 : 0.2)
                : NeonColors.textDim.withValues(alpha: 0.1),
          ),
          boxShadow: stars > 0
              ? [
                  BoxShadow(
                    color: NeonColors.glowOuter(color),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isUnlocked)
              Icon(
                Icons.lock_rounded,
                color: NeonColors.textDim.withValues(alpha: 0.3),
                size: 18,
              )
            else ...[
              Text(
                levelId.toString(),
                style: TextStyle(
                  fontFamily: AppFonts.neonScore,
                  fontSize: 10,
                  color: stars > 0 ? color : NeonColors.textDim,
                ),
              ),
              if (stars > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Icon(
                      i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                      color: i < stars ? NeonColors.yellow : NeonColors.textDim,
                      size: 10,
                    );
                  }),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
