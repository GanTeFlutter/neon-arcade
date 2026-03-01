import 'package:akillisletme/feature/games/neon_pong/model/power_up.dart';
import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/widget/neon/neon_progress_bar.dart';
import 'package:flutter/material.dart';

/// Active power-up timer bars.
class PongActiveEffectsBar extends StatelessWidget {
  const PongActiveEffectsBar({required this.effects, super.key});

  final Map<PowerUpType, double> effects;

  static const _maxDurations = <PowerUpType, double>{
    PowerUpType.widePaddle: 5,
    PowerUpType.magnetic: 8,
    PowerUpType.fireball: 5,
    PowerUpType.freezeAI: 2,
    PowerUpType.shrinkAI: 5,
    PowerUpType.blindAI: 3,
    PowerUpType.slowAI: 4,
  };

  @override
  Widget build(BuildContext context) {
    final entries = effects.entries.toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final entry in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              children: [
                Icon(entry.key.icon, color: entry.key.color, size: 12),
                const SizedBox(width: 4),
                Text(
                  entry.key.label,
                  style: TextStyle(
                    fontFamily: AppFonts.neonScore,
                    fontSize: 6,
                    color: entry.key.color.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: NeonProgressBar(
                    progress: entry.value / (_maxDurations[entry.key] ?? 5),
                    color: entry.key.color,
                    height: 4,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
