import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';

/// "PERFECT!" animated text.
/// Visible briefly, scales up and fades away.
class PerfectFlash extends StatefulWidget {
  const PerfectFlash({required this.combo, super.key});

  final int combo;

  @override
  State<PerfectFlash> createState() => _PerfectFlashState();
}

class _PerfectFlashState extends State<PerfectFlash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scale = Tween<double>(begin: 0.5, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1),
      ),
    );
    _controller.forward();
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
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(
          scale: _scale.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const NeonText(
                'PERFECT!',
                color: NeonColors.yellow,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
              if (widget.combo >= 3)
                NeonText(
                  'x${widget.combo}',
                  color: NeonColors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
