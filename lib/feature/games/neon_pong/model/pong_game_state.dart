import 'package:akillisletme/feature/games/neon_pong/model/pong_ball.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_boss.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_combo.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_level_config.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_obstacle.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_paddle.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_particle.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_projectile.dart';
import 'package:akillisletme/feature/games/neon_pong/model/power_up.dart';

/// Neon Pong game state — supports all game modes.
class PongGameState {
  PongGameState();

  // ── Mode ───────────────────────────────────────────────────
  PongMode mode = PongMode.endless;
  PongLevelConfig? levelConfig;

  // ── Balls ──────────────────────────────────────────────────
  final List<PongBall> balls = [];
  static const int maxBalls = 5;

  // ── Paddles ────────────────────────────────────────────────
  final PongPaddle playerPaddle = PongPaddle();
  final PongPaddle aiPaddle = PongPaddle(x: 0.5, width: 0.2, y: 40);

  // ── Score & Lives ──────────────────────────────────────────
  int playerScore = 0;
  int aiScore = 0;
  int lives = 3;

  // ── Status ─────────────────────────────────────────────────
  bool isGameOver = false;
  bool hasStarted = false;
  bool isPaused = false;
  bool isLevelComplete = false;
  int earnedStars = 0;

  // ── Power-ups ──────────────────────────────────────────────
  final List<PowerUp> fallingPowerUps = [];
  double powerUpTimer = 0;
  double powerUpInterval = 8;

  /// Active timed effects: PowerUpType -> remaining duration.
  final Map<PowerUpType, double> activeEffects = {};

  /// Whether the shield is active.
  bool shieldActive = false;

  /// Laser bolts (player laser power-up).
  final List<PongProjectile> playerLasers = [];

  // ── Combo ──────────────────────────────────────────────────
  final PongCombo combo = PongCombo();

  // ── Obstacles ──────────────────────────────────────────────
  final List<PongObstacle> obstacles = [];

  // ── Boss ───────────────────────────────────────────────────
  PongBoss? boss;
  final List<PongProjectile> bossProjectiles = [];

  // ── Particles ──────────────────────────────────────────────
  final List<PongParticle> particles = [];
  static const int maxParticles = 50;

  // ── Effects ────────────────────────────────────────────────
  /// Screen shake offset.
  double shakeX = 0;
  double shakeY = 0;
  double shakeTimer = 0;

  /// Slow motion factor (1.0 = normal).
  double slowMotionFactor = 1.0;
  double slowMotionTimer = 0;

  /// Chromatic aberration intensity.
  double chromaticAberration = 0;

  /// Whether last-life slow motion has been triggered.
  bool lastLifeSlowTriggered = false;

  // ── Quick Match ────────────────────────────────────────────
  /// Quick match: winning score.
  static const int quickMatchWinScore = 11;
  QuickMatchDifficulty quickMatchDifficulty = QuickMatchDifficulty.medium;

  /// Quick match winner: true = player, false = AI, null = in progress.
  bool? quickMatchWinner;

  void reset() {
    balls.clear();
    playerPaddle.reset();
    aiPaddle
      ..reset()
      ..y = 40;
    playerScore = 0;
    aiScore = 0;
    lives = levelConfig?.lives ?? 3;
    isGameOver = false;
    hasStarted = false;
    isPaused = false;
    isLevelComplete = false;
    earnedStars = 0;
    fallingPowerUps.clear();
    powerUpTimer = 0;
    powerUpInterval = levelConfig?.powerUpInterval ?? 8;
    activeEffects.clear();
    shieldActive = false;
    playerLasers.clear();
    combo.reset();
    obstacles.clear();
    boss?.reset();
    bossProjectiles.clear();
    particles.clear();
    shakeX = 0;
    shakeY = 0;
    shakeTimer = 0;
    slowMotionFactor = 1.0;
    slowMotionTimer = 0;
    chromaticAberration = 0;
    lastLifeSlowTriggered = false;
    quickMatchWinner = null;
  }
}
