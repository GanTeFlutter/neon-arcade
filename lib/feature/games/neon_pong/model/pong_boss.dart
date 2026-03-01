/// Boss attack patterns.
enum BossAttackPattern {
  /// Spread shot (3-7 projectiles in a fan).
  spreadShot,

  /// Crystal shield (deflects balls).
  crystalShield,

  /// Laser beam (vertical/horizontal).
  laserBeam,

  /// Clone spawn (spawns extra balls).
  cloneSpawn,

  /// Screen blackout effect.
  screenBlackout,

  /// Area blast (circular projectile burst).
  areaBlast,
}

/// Boss entity.
class PongBoss {
  PongBoss({
    required this.name,
    required this.maxHp,
    required this.patterns,
    required this.paddleWidth,
    this.moveSpeed = 120,
    this.rageThreshold = 0.3,
    this.attackIntervalBase = 2.2,
    this.attackIntervalRage = 1.0,
    this.projectileSpeed = 280,
    this.projectileSpeedRage = 360,
  })  : hp = maxHp,
        currentHp = maxHp.toDouble();

  final String name;
  final int maxHp;
  final List<BossAttackPattern> patterns;
  final double paddleWidth;
  final double moveSpeed;
  final double rageThreshold;

  /// Attack interval (seconds).
  final double attackIntervalBase;
  final double attackIntervalRage;

  /// Projectile speed.
  final double projectileSpeed;
  final double projectileSpeedRage;

  /// Current HP.
  int hp;
  double currentHp;

  /// Boss paddle position (normalized 0-1).
  double x = 0.5;

  /// Boss paddle Y position (top side).
  double y = 40;

  /// Movement direction.
  int direction = 1;

  /// Whether rage mode is active (HP below threshold).
  bool get isRaging => hp / maxHp <= rageThreshold;

  /// Current attack pattern index.
  int currentPatternIndex = 0;

  /// Attack cooldown timer.
  double attackCooldown = 0;

  /// Attack interval based on rage state.
  double get attackInterval =>
      isRaging ? attackIntervalRage : attackIntervalBase;

  /// Current projectile speed based on rage state.
  double get currentProjectileSpeed =>
      isRaging ? projectileSpeedRage : projectileSpeed;

  /// Whether the shield is active.
  bool shieldActive = false;
  double shieldTimer = 0;

  BossAttackPattern get currentPattern =>
      patterns[currentPatternIndex % patterns.length];

  void nextPattern() {
    currentPatternIndex = (currentPatternIndex + 1) % patterns.length;
  }

  void takeDamage(int damage) {
    hp = (hp - damage).clamp(0, maxHp);
    currentHp = hp.toDouble();
  }

  bool get isDead => hp <= 0;

  void reset() {
    hp = maxHp;
    currentHp = maxHp.toDouble();
    x = 0.5;
    currentPatternIndex = 0;
    attackCooldown = 0;
    shieldActive = false;
    shieldTimer = 0;
  }
}
