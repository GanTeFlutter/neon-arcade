import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Text widget with neon glow effect.
///
/// 2-layer shadow: inner layer (high opacity, low blur)
/// and outer layer (low opacity, high blur).
///
/// When [enablePulse] is true, the widget creates its own AnimationController
/// and the glow intensity oscillates between 0.6-1.0.
class NeonText extends StatefulWidget {
  const NeonText(
    this.text, {
    required this.color,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.textAlign,
    this.enablePulse = false,
    this.letterSpacing,
    this.maxLines,
    this.overflow,
    super.key,
  });

  final String text;
  final Color color;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final bool enablePulse;
  final double? letterSpacing;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  State<NeonText> createState() => _NeonTextState();
}

class _NeonTextState extends State<NeonText>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    if (widget.enablePulse) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      );
      _animation = Tween<double>(begin: 0.6, end: 1).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
      );
      _controller!.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enablePulse && _animation != null) {
      return AnimatedBuilder(
        animation: _animation!,
        builder: (_, __) => _buildText(_animation!.value),
      );
    }
    return _buildText(1);
  }

  Widget _buildText(double glowIntensity) {
    final color = widget.color;
    return Text(
      widget.text,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      style: TextStyle(
        fontFamily: widget.fontFamily ?? AppFonts.neonDisplay,
        fontSize: widget.fontSize ?? 24,
        fontWeight: widget.fontWeight ?? FontWeight.w700,
        letterSpacing: widget.letterSpacing ?? 1,
        color: color,
        shadows: [
          // Inner layer: high opacity, low blur
          Shadow(
            color: NeonColors.glowInner(color).withValues(
              alpha: 0.8 * glowIntensity,
            ),
            blurRadius: 4,
          ),
          // Outer layer: low opacity, high blur
          Shadow(
            color: NeonColors.glowOuter(color).withValues(
              alpha: 0.4 * glowIntensity,
            ),
            blurRadius: 16,
          ),
        ],
      ),
    );
  }
}
