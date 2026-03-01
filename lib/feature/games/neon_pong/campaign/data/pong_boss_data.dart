import 'package:akillisletme/feature/games/neon_pong/model/pong_boss.dart';

/// 5 boss configurations.
final class PongBossData {
  PongBossData._();

  /// Neon City boss: Neon Serpent — Spread shot.
  static PongBoss neonSerpent() => PongBoss(
        name: 'NEON SERPENT',
        maxHp: 15,
        paddleWidth: 0.26,
        moveSpeed: 160,
        attackIntervalBase: 2.0,
        attackIntervalRage: 0.9,
        projectileSpeed: 260,
        projectileSpeedRage: 340,
        patterns: [
          BossAttackPattern.spreadShot,
          BossAttackPattern.areaBlast,
          BossAttackPattern.spreadShot,
          BossAttackPattern.laserBeam,
          BossAttackPattern.spreadShot,
        ],
      );

  /// Magenta Forge boss: Prism Guardian — Crystal shield + laser.
  static PongBoss prismGuardian() => PongBoss(
        name: 'PRISM GUARDIAN',
        maxHp: 22,
        paddleWidth: 0.24,
        moveSpeed: 150,
        attackIntervalBase: 1.8,
        attackIntervalRage: 0.8,
        projectileSpeed: 280,
        projectileSpeedRage: 380,
        patterns: [
          BossAttackPattern.crystalShield,
          BossAttackPattern.laserBeam,
          BossAttackPattern.spreadShot,
          BossAttackPattern.laserBeam,
          BossAttackPattern.areaBlast,
          BossAttackPattern.crystalShield,
        ],
      );

  /// Toxic Grid boss: Laser Core — Laser beam + area effect.
  static PongBoss laserCore() => PongBoss(
        name: 'LASER CORE',
        maxHp: 28,
        paddleWidth: 0.22,
        moveSpeed: 170,
        attackIntervalBase: 1.6,
        attackIntervalRage: 0.7,
        projectileSpeed: 300,
        projectileSpeedRage: 420,
        rageThreshold: 0.35,
        patterns: [
          BossAttackPattern.laserBeam,
          BossAttackPattern.areaBlast,
          BossAttackPattern.laserBeam,
          BossAttackPattern.spreadShot,
          BossAttackPattern.areaBlast,
          BossAttackPattern.laserBeam,
          BossAttackPattern.crystalShield,
        ],
      );

  /// Solar Flare boss: Clone Master — Clone spawning.
  static PongBoss cloneMaster() => PongBoss(
        name: 'CLONE MASTER',
        maxHp: 35,
        paddleWidth: 0.22,
        moveSpeed: 180,
        attackIntervalBase: 1.5,
        attackIntervalRage: 0.65,
        projectileSpeed: 320,
        projectileSpeedRage: 440,
        rageThreshold: 0.35,
        patterns: [
          BossAttackPattern.cloneSpawn,
          BossAttackPattern.spreadShot,
          BossAttackPattern.laserBeam,
          BossAttackPattern.cloneSpawn,
          BossAttackPattern.areaBlast,
          BossAttackPattern.spreadShot,
          BossAttackPattern.cloneSpawn,
          BossAttackPattern.crystalShield,
        ],
      );

  /// Red Void boss: Dark Void — Screen blackout + all attacks.
  static PongBoss darkVoid() => PongBoss(
        name: 'DARK VOID',
        maxHp: 45,
        paddleWidth: 0.26,
        moveSpeed: 200,
        attackIntervalBase: 1.3,
        attackIntervalRage: 0.55,
        projectileSpeed: 350,
        projectileSpeedRage: 480,
        rageThreshold: 0.4,
        patterns: [
          BossAttackPattern.screenBlackout,
          BossAttackPattern.laserBeam,
          BossAttackPattern.spreadShot,
          BossAttackPattern.areaBlast,
          BossAttackPattern.cloneSpawn,
          BossAttackPattern.laserBeam,
          BossAttackPattern.screenBlackout,
          BossAttackPattern.crystalShield,
          BossAttackPattern.spreadShot,
          BossAttackPattern.areaBlast,
        ],
      );

  /// Create boss by world index.
  static PongBoss fromWorldIndex(int worldIndex) {
    switch (worldIndex) {
      case 0:
        return neonSerpent();
      case 1:
        return prismGuardian();
      case 2:
        return laserCore();
      case 3:
        return cloneMaster();
      case 4:
        return darkVoid();
      default:
        return neonSerpent();
    }
  }
}
