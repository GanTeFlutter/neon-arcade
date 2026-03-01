import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Progress bar with neon glow effect.
/// Used for timers, health bars, level progress, etc.
class NeonProgressBar extends StatelessWidget {
  const NeonProgressBar({
    required this.progress,
    required this.color,
    this.height = 6,
    this.backgroundColor,
    this.borderRadius = 3,
    super.key,
  });

  /// Progress value in the range 0.0 – 1.0.
  final double progress;
  final Color color;
  final double height;
  final Color? backgroundColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0, 1),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: NeonColors.glowInner(color),
                blurRadius: 4,
              ),
              BoxShadow(
                color: NeonColors.glowOuter(color),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
