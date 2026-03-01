import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Lives indicator.
class PongLivesBar extends StatelessWidget {
  const PongLivesBar({
    required this.lives,
    this.maxLives = 3,
    super.key,
  });

  final int lives;
  final int maxLives;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLives.clamp(1, 5), (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Icon(
            Icons.favorite_rounded,
            color: i < lives
                ? NeonColors.red
                : NeonColors.textDim.withValues(alpha: 0.2),
            size: 18,
            shadows: i < lives
                ? [
                    Shadow(
                      color: NeonColors.glowOuter(NeonColors.red),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
