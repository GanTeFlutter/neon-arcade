import 'dart:ui';

import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_button.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';

/// Game pause menu.
/// Blur background + Resume / Restart / Main Menu buttons.
class PauseMenuOverlay extends StatelessWidget {
  const PauseMenuOverlay({
    required this.color,
    this.onResume,
    this.onRestart,
    this.onHome,
    super.key,
  });

  final Color color;
  final VoidCallback? onResume;
  final VoidCallback? onRestart;
  final VoidCallback? onHome;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: ColoredBox(
        color: NeonColors.background.withValues(alpha: 0.7),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NeonText(
                'PAUSED',
                color: color,
                fontSize: 32,
                enablePulse: true,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 220,
                child: NeonButton(
                  label: 'DEVAM ET',
                  color: NeonColors.cyan,
                  icon: Icons.play_arrow_rounded,
                  onPressed: onResume,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 220,
                child: NeonButton(
                  label: 'TEKRAR',
                  color: NeonColors.yellow,
                  icon: Icons.refresh_rounded,
                  onPressed: onRestart,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 220,
                child: NeonButton(
                  label: 'ANA MENU',
                  color: NeonColors.textDim,
                  icon: Icons.home_rounded,
                  onPressed: onHome,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
