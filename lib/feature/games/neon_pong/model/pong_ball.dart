import 'dart:math';
import 'dart:ui';

/// Pong ball entity.
class PongBall {
  PongBall({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    this.radius = 8,
  });

  double x;
  double y;
  double vx;
  double vy;
  double radius;

  /// Spin (radians/s). Applied on paddle hit based on angle.
  double spin = 0;

  /// Whether fireball mode is active (destroys obstacles).
  bool isFireball = false;

  /// Fireball remaining duration.
  double fireballTimer = 0;

  /// Portal cooldown (seconds). Prevents re-entering a portal immediately.
  double portalCooldown = 0;

  /// Trail positions for rendering.
  final List<Offset> trail = [];
  static const int maxTrail = 12;

  void updateTrail() {
    trail.add(Offset(x, y));
    if (trail.length > maxTrail) {
      trail.removeAt(0);
    }
  }

  double get speed => sqrt(vx * vx + vy * vy);

  /// Speed-based trail color tier: 0=blue, 1=green, 2=yellow, 3=red.
  int get speedTier {
    final s = speed;
    if (s < 350) return 0;
    if (s < 500) return 1;
    if (s < 650) return 2;
    return 3;
  }
}
