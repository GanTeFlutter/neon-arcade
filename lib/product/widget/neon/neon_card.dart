import 'dart:async';

import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:flutter/material.dart';

/// Neon card for game cards on the main menu.
/// Colored line on the left edge, low-opacity fill, tap animation.
class NeonCard extends StatefulWidget {
  const NeonCard({
    required this.color,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    super.key,
  });

  final Color color;
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  State<NeonCard> createState() => _NeonCardState();
}

class _NeonCardState extends State<NeonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.02).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _onTapDown(TapDownDetails _) async {
    await _scaleController.forward();
  }

  Future<void> _onTapUp(TapUpDetails _) async {
    await _scaleController.reverse();
    unawaited(locator.audioService.playBlip());
    unawaited(locator.vibrationService.light());
    widget.onTap?.call();
  }

  Future<void> _onTapCancel() async {
    await _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (_, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: NeonColors.cardTint(widget.color),
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: widget.color, width: 2.5),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.08),
                blurRadius: 12,
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
