import 'dart:ui';

/// Spark particle for visual effects.
class PongParticle {
  PongParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    this.lifetime = 0.6,
    this.radius = 2,
  }) : remainingLife = lifetime;

  double x;
  double y;
  double vx;
  double vy;
  Color color;
  double lifetime;
  double remainingLife;
  double radius;

  /// Life ratio from 0.0 to 1.0.
  double get lifeRatio => (remainingLife / lifetime).clamp(0, 1);

  bool get isDead => remainingLife <= 0;

  void update(double dt) {
    x += vx * dt;
    y += vy * dt;
    remainingLife -= dt;
    // Damping
    vx *= 0.98;
    vy *= 0.98;
  }
}
