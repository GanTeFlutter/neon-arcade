import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// A single stacked block widget.
/// Has neon glow effect, PERFECT blocks glow extra bright.
class StackBlockWidget extends StatelessWidget {
  const StackBlockWidget({
    required this.color,
    required this.width,
    required this.height,
    required this.left,
    required this.bottom,
    this.isPerfect = false,
    super.key,
  });

  final Color color;
  final double width;
  final double height;
  final double left;
  final double bottom;
  final bool isPerfect;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      bottom: bottom,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.9),
              color.withValues(alpha: 0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(
            color: color.withValues(alpha: isPerfect ? 1 : 0.7),
          ),
          boxShadow: [
            BoxShadow(
              color: NeonColors.glowInner(color),
              blurRadius: isPerfect ? 8 : 3,
            ),
            BoxShadow(
              color: NeonColors.glowOuter(color),
              blurRadius: isPerfect ? 20 : 10,
            ),
          ],
        ),
      ),
    );
  }
}
