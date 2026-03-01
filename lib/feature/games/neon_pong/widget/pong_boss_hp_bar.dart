import 'package:akillisletme/feature/games/neon_pong/model/pong_boss.dart';
import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_progress_bar.dart';
import 'package:flutter/material.dart';

/// Boss HP indicator.
class PongBossHpBar extends StatelessWidget {
  const PongBossHpBar({required this.boss, super.key});

  final PongBoss boss;

  @override
  Widget build(BuildContext context) {
    final hpRatio = boss.hp / boss.maxHp;
    final color = boss.isRaging ? NeonColors.red : NeonColors.magenta;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (boss.isRaging)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.whatshot_rounded,
                  color: NeonColors.red,
                  size: 12,
                ),
              ),
            Text(
              boss.name,
              style: TextStyle(
                fontFamily: AppFonts.neonScore,
                fontSize: 7,
                color: color,
                shadows: [
                  Shadow(
                    color: NeonColors.glowOuter(color),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              '${boss.hp}/${boss.maxHp}',
              style: TextStyle(
                fontFamily: AppFonts.neonScore,
                fontSize: 7,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        NeonProgressBar(
          progress: hpRatio,
          color: color,
          height: 5,
        ),
      ],
    );
  }
}
