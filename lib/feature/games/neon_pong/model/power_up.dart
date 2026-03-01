import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Power-up types (10 total).
/// First 6 benefit the player, last 4 target the AI.
enum PowerUpType {
  // Player power-ups
  widePaddle(NeonColors.green, Icons.open_in_full_rounded, 'WIDE'),
  magnetic(NeonColors.cyan, Icons.attractions_rounded, 'MAGNET'),
  multiBall(NeonColors.magenta, Icons.scatter_plot_rounded, 'MULTI'),
  fireball(Color(0xFFFF6B35), Icons.local_fire_department_rounded, 'FIRE'),
  shield(NeonColors.yellow, Icons.shield_rounded, 'SHIELD'),
  laser(NeonColors.red, Icons.flash_on_rounded, 'LASER'),

  // Anti-AI power-ups
  freezeAI(Color(0xFF88DDFF), Icons.ac_unit_rounded, 'FREEZE'),
  shrinkAI(Color(0xFFFF88DD), Icons.compress_rounded, 'SHRINK'),
  blindAI(Color(0xFF333366), Icons.visibility_off_rounded, 'BLIND'),
  slowAI(Color(0xFF88FFBB), Icons.slow_motion_video_rounded, 'SLOW');

  const PowerUpType(this.color, this.icon, this.label);

  final Color color;
  final IconData icon;
  final String label;

  /// Whether this power-up benefits the player (true) or targets AI (false).
  bool get isPlayerBuff => index <= 5;
}

/// Falling power-up on the field.
class PowerUp {
  PowerUp({
    required this.type,
    required this.x,
    required this.y,
    this.vy = 80,
    this.radius = 12,
  });

  final PowerUpType type;
  double x;
  double y;
  double vy;
  double radius;

  /// Rotation angle for spinning icon animation.
  double rotation = 0;
}
