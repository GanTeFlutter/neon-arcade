import 'package:flutter/material.dart';

/// Neon pulse animation mixin.
/// Glow intensity oscillates between 0.6 and 1.0 with a 1.5-second period.
/// Can be used with any StatefulWidget.
///
/// Usage:
/// ```dart
/// class _MyState extends State<MyWidget>
///     with SingleTickerProviderStateMixin, PulseAnimationMixin {
///   @override
///   Widget build(BuildContext context) {
///     return AnimatedBuilder(
///       animation: pulseAnimation,
///       builder: (_, __) => Opacity(opacity: pulseValue, child: ...),
///     );
///   }
/// }
/// ```
mixin PulseAnimationMixin<T extends StatefulWidget> on State<T>, TickerProvider {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  /// Value oscillating between 0.6 – 1.0.
  double get pulseValue => _pulseAnimation.value;

  /// Animation to be used with AnimatedBuilder.
  Animation<double> get pulseAnimation => _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }
}
