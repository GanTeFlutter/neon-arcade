import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Container with neon glow border.
/// Provides a bright neon effect with 2-layer BoxShadow.
class NeonGlowBox extends StatelessWidget {
  const NeonGlowBox({
    required this.color,
    required this.child,
    this.borderRadius = 12,
    this.borderWidth = 1.5,
    this.padding,
    this.glowIntensity = 1.0,
    this.fillColor,
    super.key,
  });

  final Color color;
  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final double glowIntensity;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: fillColor ?? NeonColors.cardTint(color),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.6), width: borderWidth),
        boxShadow: [
          // Inner glow
          BoxShadow(
            color: NeonColors.glowInner(color).withValues(
              alpha: 0.3 * glowIntensity,
            ),
            blurRadius: 4,
          ),
          // Outer glow
          BoxShadow(
            color: NeonColors.glowOuter(color).withValues(
              alpha: 0.15 * glowIntensity,
            ),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}
