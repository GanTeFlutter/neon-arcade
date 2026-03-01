import 'package:akillisletme/feature/games/neon_pong/model/pong_combo.dart';
import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Combo multiplier display (pulsing neon).
class PongComboDisplay extends StatelessWidget {
  const PongComboDisplay({required this.combo, super.key});

  final PongCombo combo;

  @override
  Widget build(BuildContext context) {
    final color = _comboColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: NeonColors.glowOuter(color),
            blurRadius: 8 * combo.glowIntensity,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${combo.multiplier}x',
            style: TextStyle(
              fontFamily: AppFonts.neonScore,
              fontSize: 12,
              color: color,
              shadows: [
                Shadow(
                  color: NeonColors.glowInner(color),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          Text(
            '${combo.streak}',
            style: TextStyle(
              fontFamily: AppFonts.neonScore,
              fontSize: 8,
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Color get _comboColor {
    if (combo.streak >= 20) return NeonColors.red;
    if (combo.streak >= 10) return NeonColors.yellow;
    if (combo.streak >= 5) return NeonColors.green;
    return NeonColors.cyan;
  }
}
