import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:flutter/material.dart';

/// Icon button with neon glow effect.
/// For toolbar, app bar, and in-game actions.
class NeonIconButton extends StatelessWidget {
  const NeonIconButton({
    required this.icon,
    required this.color,
    this.onPressed,
    this.size = 24,
    this.enableGlow = true,
    super.key,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final double size;
  final bool enableGlow;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed == null
          ? null
          : () {
              locator.vibrationService.light();
              onPressed!.call();
            },
      icon: Icon(
        icon,
        color: color,
        size: size,
        shadows: enableGlow
            ? [
                Shadow(
                  color: NeonColors.glowInner(color),
                  blurRadius: 4,
                ),
                Shadow(
                  color: NeonColors.glowOuter(color),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
    );
  }
}
