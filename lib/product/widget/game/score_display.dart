import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Compact score display.
/// Shows a neon-glowing number with PressStart2P font.
class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({
    required this.score,
    this.label,
    this.color,
    this.fontSize = 16,
    super.key,
  });

  final int score;
  final String? label;
  final Color? color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final c = color ?? NeonColors.yellow;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Text(
            label!,
            style: const TextStyle(
              fontFamily: AppFonts.body,
              fontSize: 10,
              color: NeonColors.textDim,
              letterSpacing: 0.5,
            ),
          ),
        Text(
          _formatScore(score),
          style: TextStyle(
            fontFamily: AppFonts.neonScore,
            fontSize: fontSize,
            color: c,
            shadows: [
              Shadow(color: NeonColors.glowInner(c), blurRadius: 4),
              Shadow(color: NeonColors.glowOuter(c), blurRadius: 12),
            ],
          ),
        ),
      ],
    );
  }

  String _formatScore(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}
