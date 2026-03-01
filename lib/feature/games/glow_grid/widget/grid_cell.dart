import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// A single grid cell.
/// On = bright neon, Off = dark, Locked = lock icon.
class GridCell extends StatelessWidget {
  const GridCell({
    required this.isOn,
    required this.isLocked,
    required this.color,
    required this.onTap,
    super.key,
  });

  final bool isOn;
  final bool isLocked;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isLocked) {
      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: NeonColors.surfaceDark,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: NeonColors.textDim.withValues(alpha: 0.2),
          ),
        ),
        child: const Center(
          child: Icon(Icons.lock_rounded, color: NeonColors.textDim, size: 16),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isOn ? color.withValues(alpha: 0.3) : NeonColors.surfaceDark,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isOn ? color : NeonColors.textDim.withValues(alpha: 0.15),
            width: isOn ? 1.5 : 0.5,
          ),
          boxShadow: isOn
              ? [
                  BoxShadow(
                    color: NeonColors.glowInner(color),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: NeonColors.glowOuter(color),
                    blurRadius: 14,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
