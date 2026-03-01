import 'dart:ui';

import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_button.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';

/// Maze süre doldu overlay'ı.
class MazeGameOverOverlay extends StatelessWidget {
  const MazeGameOverOverlay({
    required this.color,
    this.onRetry,
    this.onLevelSelect,
    super.key,
  });

  final Color color;
  final VoidCallback? onRetry;
  final VoidCallback? onLevelSelect;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: ColoredBox(
          color: NeonColors.background.withValues(alpha: 0.75),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const NeonText(
                  'TIME UP!',
                  color: NeonColors.red,
                  fontSize: 28,
                  enablePulse: true,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 220,
                  child: NeonButton(
                    label: 'RETRY',
                    color: color,
                    icon: Icons.replay_rounded,
                    onPressed: onRetry,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 220,
                  child: NeonButton(
                    label: 'LEVELS',
                    color: NeonColors.textDim,
                    icon: Icons.grid_view_rounded,
                    onPressed: onLevelSelect,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
