import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// The falling piece of a trimmed block.
/// Slides down with a short animation and fades away.
class FallingPiece extends StatefulWidget {
  const FallingPiece({
    required this.color,
    required this.width,
    required this.height,
    required this.left,
    required this.bottom,
    super.key,
  });

  final Color color;
  final double width;
  final double height;
  final double left;
  final double bottom;

  @override
  State<FallingPiece> createState() => _FallingPieceState();
}

class _FallingPieceState extends State<FallingPiece>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fall;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fall = Tween<double>(begin: 0, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInQuad),
    );
    _opacity = Tween<double>(begin: 0.8, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
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
      builder: (_, __) => Positioned(
        left: widget.left,
        bottom: widget.bottom - _fall.value,
        child: Opacity(
          opacity: _opacity.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.5),
              border: Border.all(color: widget.color.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: NeonColors.glowOuter(widget.color),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
