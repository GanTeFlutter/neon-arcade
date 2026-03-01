import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// 3-star rating display (for level-based games).
/// [stars] takes a value in the range 0-3.
class NeonStarRating extends StatefulWidget {
  const NeonStarRating({
    required this.stars,
    this.color,
    this.size = 28,
    this.animate = false,
    super.key,
  });

  final int stars;
  final Color? color;
  final double size;
  final bool animate;

  @override
  State<NeonStarRating> createState() => _NeonStarRatingState();
}

class _NeonStarRatingState extends State<NeonStarRating>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      )..forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final starColor = widget.color ?? NeonColors.yellow;
    final dimColor = Colors.white.withValues(alpha: 0.15);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final isLit = i < widget.stars;

        Widget star = Icon(
          isLit ? Icons.star_rounded : Icons.star_outline_rounded,
          color: isLit ? starColor : dimColor,
          size: widget.size,
          shadows: isLit
              ? [
                  Shadow(color: NeonColors.glowInner(starColor), blurRadius: 4),
                  Shadow(
                    color: NeonColors.glowOuter(starColor),
                    blurRadius: 12,
                  ),
                ]
              : null,
        );

        if (widget.animate && _controller != null && isLit) {
          final delay = i / 3;
          final animation = CurvedAnimation(
            parent: _controller!,
            curve: Interval(delay, (delay + 0.4).clamp(0, 1),
                curve: Curves.elasticOut),
          );
          star = ScaleTransition(scale: animation, child: star);
        }

        return star;
      }),
    );
  }
}
