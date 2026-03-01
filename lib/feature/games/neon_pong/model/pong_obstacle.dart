import 'dart:ui';

/// Obstacle types.
enum ObstacleType {
  /// Teleport portal (paired — ball enters one and exits the other).
  portal,

  /// Static blocker (ball bounces off).
  staticBlocker,

  /// Moving blocker (ball bounces off).
  movingBlocker,

  /// Black hole (applies gravitational pull).
  blackHole,

  /// Speed zone (ball accelerates or decelerates).
  speedZone,

  /// Invisible wall (destroyable with fireball).
  invisibleWall,
}

/// Environmental obstacle.
class PongObstacle {
  PongObstacle({
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.pairedPortalIndex,
    this.movingSpeed = 0,
    this.movingDirection = 1,
    this.movingMinX,
    this.movingMaxX,
    this.pullStrength = 100,
    this.speedMultiplier = 1.5,
    this.hp = 1,
  });

  final ObstacleType type;
  double x;
  double y;
  double width;
  double height;

  /// Portal: paired portal index in the obstacles list.
  int? pairedPortalIndex;

  /// Moving blocker: speed and direction.
  double movingSpeed;
  int movingDirection;
  double? movingMinX;
  double? movingMaxX;

  /// Black hole: gravitational pull strength.
  double pullStrength;

  /// Speed zone: speed multiplier.
  double speedMultiplier;

  /// Hit points (destroyable with fireball).
  int hp;

  /// Portal rotation angle for animation.
  double portalRotation = 0;

  /// Whether the obstacle is still active.
  bool isActive = true;

  Rect get rect => Rect.fromLTWH(x, y, width, height);
  Offset get center => Offset(x + width / 2, y + height / 2);
}
