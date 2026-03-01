/// Combo system for consecutive paddle hits.
class PongCombo {
  /// Consecutive paddle bounce streak.
  int streak = 0;

  /// Combo multiplier (1x, 2x, 3x, 5x).
  int get multiplier {
    if (streak >= 20) return 5;
    if (streak >= 10) return 3;
    if (streak >= 5) return 2;
    return 1;
  }

  /// Glow intensity (0.0 – 1.0).
  double get glowIntensity {
    if (streak >= 20) return 1.0;
    if (streak >= 10) return 0.8;
    if (streak >= 5) return 0.6;
    if (streak >= 3) return 0.4;
    return 0.2;
  }

  /// Whether combo text should be displayed.
  bool get shouldShowText => streak >= 3;

  void increment() => streak++;

  void reset() => streak = 0;
}
