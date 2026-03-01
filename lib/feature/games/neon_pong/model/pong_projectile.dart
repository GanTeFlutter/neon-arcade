/// Boss projectile types.
enum ProjectileType {
  /// Standard bullet.
  bullet,

  /// Laser beam (wide, vertical/horizontal).
  laser,
}

/// Boss projectile.
class PongProjectile {
  PongProjectile({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    this.type = ProjectileType.bullet,
    this.radius = 5,
    this.damage = 1,
    this.lifetime = 5,
  });

  double x;
  double y;
  double vx;
  double vy;
  final ProjectileType type;
  final double radius;
  final int damage;

  /// Remaining lifetime (seconds).
  double lifetime;

  /// Laser width for rendering.
  double laserWidth = 8;

  /// Whether the laser is active (after charge).
  bool laserActive = false;

  /// Laser charge timer.
  double laserChargeTimer = 0;

  bool get isExpired => lifetime <= 0;
}
