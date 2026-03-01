import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:akillisletme/product/widget/neon/neon_glow_box.dart';
import 'package:flutter/material.dart';

/// Mode selection card.
class PongModeCard extends StatelessWidget {
  const PongModeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator.audioService.playBlip();
        locator.vibrationService.light();
        onTap();
      },
      child: NeonGlowBox(
        color: color,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.neonDisplay,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color,
                      letterSpacing: 1,
                      shadows: [
                        Shadow(
                          color: NeonColors.glowOuter(color),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: AppFonts.neonDisplay,
                      fontSize: 11,
                      color: NeonColors.textDim,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: color.withValues(alpha: 0.5),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
