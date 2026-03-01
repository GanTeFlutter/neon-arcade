/// Paddle effect types.
enum PaddleEffect {
  freeze,
  slow,
  blind,
  shrink,
  magnet,
}

/// Pong paddle.
class PongPaddle {
  PongPaddle({
    this.x = 0.5,
    this.width = 0.2,
    this.y = 30,
  }) : baseWidth = width;

  /// Center X position (normalized 0-1).
  double x;

  /// Width (normalized 0-1).
  double width;

  /// Y position (pixels from top/bottom).
  double y;

  /// Original width before power-up modifications.
  double baseWidth;

  /// Whether magnetic paddle mode is active.
  bool isMagnetic = false;

  /// Relative X position (0-1) of the stuck ball on the paddle.
  double? magnetBallRelativeX;

  /// Active effects and their remaining durations.
  final Map<PaddleEffect, double> activeEffects = {};

  bool get isFrozen => activeEffects.containsKey(PaddleEffect.freeze);
  bool get isSlowed => activeEffects.containsKey(PaddleEffect.slow);
  bool get isBlind => activeEffects.containsKey(PaddleEffect.blind);
  bool get isShrunk => activeEffects.containsKey(PaddleEffect.shrink);

  void reset() {
    x = 0.5;
    width = baseWidth;
    y = 30;
    isMagnetic = false;
    magnetBallRelativeX = null;
    activeEffects.clear();
  }
}
