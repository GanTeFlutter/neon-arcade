import 'dart:math';

import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Neon Arcade background animation.
/// Slowly moving, softly glowing neon dots on a black background.
/// Should be wrapped in RepaintBoundary for performance.
class NeonBackground extends StatefulWidget {
  const NeonBackground({super.key});

  @override
  State<NeonBackground> createState() => _NeonBackgroundState();
}

class _NeonBackgroundState extends State<NeonBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_NeonDot> _dots;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    final rng = Random(7);
    final colors = [
      NeonColors.cyan,
      NeonColors.magenta,
      NeonColors.green,
      NeonColors.yellow,
    ];

    _dots = List.generate(30, (i) {
      return _NeonDot(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        radius: 1.0 + rng.nextDouble() * 1.5,
        speed: 0.02 + rng.nextDouble() * 0.06,
        opacity: 0.08 + rng.nextDouble() * 0.12,
        color: colors[rng.nextInt(colors.length)],
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => CustomPaint(
        size: MediaQuery.sizeOf(context),
        painter: _NeonDotPainter(
          progress: _controller.value,
          dots: _dots,
        ),
      ),
    );
  }
}

class _NeonDot {
  const _NeonDot({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
    required this.color,
  });

  final double x;
  final double y;
  final double radius;
  final double speed;
  final double opacity;
  final Color color;
}

class _NeonDotPainter extends CustomPainter {
  _NeonDotPainter({required this.progress, required this.dots});

  final double progress;
  final List<_NeonDot> dots;

  @override
  void paint(Canvas canvas, Size size) {
    for (final dot in dots) {
      final yOffset = (dot.y + progress * dot.speed) % 1.1 - 0.05;
      final cx = dot.x * size.width;
      final cy = yOffset * size.height;

      // Outer glow
      final glowPaint = Paint()
        ..color = dot.color.withValues(alpha: dot.opacity * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(cx, cy), dot.radius * 3, glowPaint);

      // Inner dot
      final corePaint = Paint()
        ..color = dot.color.withValues(alpha: dot.opacity);
      canvas.drawCircle(Offset(cx, cy), dot.radius, corePaint);
    }
  }

  @override
  bool shouldRepaint(_NeonDotPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
