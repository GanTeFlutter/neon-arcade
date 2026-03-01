import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// 5 worlds (6 levels per world, last level is boss).
enum PongWorld {
  neonCity(0, 'NEON CITY', NeonColors.cyan, 1, 6),
  magentaForge(1, 'MAGENTA FORGE', NeonColors.magenta, 7, 12),
  toxicGrid(2, 'TOXIC GRID', NeonColors.green, 13, 18),
  solarFlare(3, 'SOLAR FLARE', NeonColors.yellow, 19, 24),
  redVoid(4, 'RED VOID', NeonColors.red, 25, 30);

  const PongWorld(
    this.worldIndex,
    this.displayName,
    this.color,
    this.startLevel,
    this.endLevel,
  );

  final int worldIndex;
  final String displayName;
  final Color color;
  final int startLevel;
  final int endLevel;

  int get levelCount => endLevel - startLevel + 1;

  /// Boss level ID (last level of each world).
  int get bossLevelId => endLevel;

  static PongWorld fromLevelId(int levelId) {
    for (final world in values) {
      if (levelId >= world.startLevel && levelId <= world.endLevel) {
        return world;
      }
    }
    return neonCity;
  }
}
