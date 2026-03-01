import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:flutter/material.dart';

/// Primary button in neon style.
/// Transparent background, neon border glow, neon text.
class NeonButton extends StatelessWidget {
  const NeonButton({
    required this.label,
    required this.color,
    this.onPressed,
    this.icon,
    this.isExpanded = true,
    this.fontSize = 14,
    super.key,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isExpanded;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isExpanded ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed == null
            ? null
            : () {
                locator.audioService.playBlip();
                locator.vibrationService.light();
                onPressed!.call();
              },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.7)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: NeonColors.cardTint(color),
        ),
        child: Row(
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.neonDisplay,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
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
          ],
        ),
      ),
    );
  }
}
