import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_progress_bar.dart';
import 'package:flutter/material.dart';

/// Maze timer widget.
class MazeTimer extends StatelessWidget {
  const MazeTimer({
    required this.timeLeft,
    required this.totalTime,
    required this.color,
    super.key,
  });

  final double timeLeft;
  final double totalTime;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ratio = (timeLeft / totalTime).clamp(0.0, 1.0);
    final displayColor = ratio < 0.25 ? NeonColors.red : color;
    final seconds = timeLeft.ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.timer_rounded,
            color: displayColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: NeonProgressBar(
              progress: ratio,
              color: displayColor,
              height: 8,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${seconds}s',
            style: TextStyle(
              fontFamily: AppFonts.neonScore,
              fontSize: 10,
              color: displayColor,
            ),
          ),
        ],
      ),
    );
  }
}
