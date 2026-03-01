import 'package:akillisletme/feature/games/neon_pong/model/pong_obstacle.dart';

/// Game mode.
enum PongMode {
  campaign,
  endless,
  quickMatch,
}

/// Quick match difficulty.
enum QuickMatchDifficulty {
  easy,
  medium,
  hard,
}

/// Level configuration.
class PongLevelConfig {
  const PongLevelConfig({
    required this.id,
    required this.worldIndex,
    required this.name,
    this.aiSpeed = 0.6,
    this.aiErrorRate = 0.3,
    this.aiReactionDelay = 0.2,
    this.ballSpeed = 280,
    this.ballSpeedIncrement = 1.02,
    this.lives = 3,
    this.requiredScore = 5,
    this.obstacles = const [],
    this.isBossLevel = false,
    this.bossName,
    this.powerUpInterval = 8,
    this.starThresholds = const [0, 3, 5],
  });

  final int id;
  final int worldIndex;
  final String name;

  /// AI speed (0-1, paddle widths per second).
  final double aiSpeed;

  /// AI error rate (0-1, lower = more accurate).
  final double aiErrorRate;

  /// AI reaction delay (seconds).
  final double aiReactionDelay;

  /// Initial ball speed.
  final double ballSpeed;

  /// Speed increment multiplier per bounce.
  final double ballSpeedIncrement;

  /// Starting lives.
  final int lives;

  /// Campaign: required score to complete.
  final int requiredScore;

  /// Obstacles.
  final List<ObstacleConfig> obstacles;

  /// Whether this is a boss level.
  final bool isBossLevel;

  /// Boss name (resolved from boss data).
  final String? bossName;

  /// Power-up spawn interval (seconds).
  final double powerUpInterval;

  /// Star thresholds: [1_star_min, 2_star_min, 3_star_min] score.
  final List<int> starThresholds;

  /// Calculate stars based on score.
  int calculateStars(int score, {int livesRemaining = 0}) {
    if (isBossLevel) {
      // Boss: stars based on remaining lives ratio.
      final ratio = livesRemaining / lives;
      if (ratio >= 0.5) return 3;
      if (ratio >= 0.25) return 2;
      return 1;
    }
    if (score >= starThresholds[2]) return 3;
    if (score >= starThresholds[1]) return 2;
    if (score >= starThresholds[0]) return 1;
    return 0;
  }
}

/// Obstacle configuration (for level data).
class ObstacleConfig {
  const ObstacleConfig({
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.pairedIndex,
    this.movingSpeed,
    this.movingMinX,
    this.movingMaxX,
    this.pullStrength,
    this.speedMultiplier,
  });

  final ObstacleType type;
  final double x;
  final double y;
  final double width;
  final double height;
  final int? pairedIndex;
  final double? movingSpeed;
  final double? movingMinX;
  final double? movingMaxX;
  final double? pullStrength;
  final double? speedMultiplier;

  PongObstacle toObstacle() {
    return PongObstacle(
      type: type,
      x: x,
      y: y,
      width: width,
      height: height,
      pairedPortalIndex: pairedIndex,
      movingSpeed: movingSpeed ?? 0,
      movingMinX: movingMinX,
      movingMaxX: movingMaxX,
      pullStrength: pullStrength ?? 100,
      speedMultiplier: speedMultiplier ?? 1.5,
    );
  }
}
