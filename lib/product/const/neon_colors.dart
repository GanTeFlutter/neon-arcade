import 'package:flutter/material.dart';

/// Neon Arcade color constants.
/// All neon glow effects and game colors are sourced from this file.
@immutable
final class NeonColors {
  const NeonColors._();

  // Background
  static const Color background = Color(0xFF0A0A1A);
  static const Color surfaceDark = Color(0xFF0F0F2A);

  // Primary neon colors
  static const Color cyan = Color(0xFF00FFFF);
  static const Color magenta = Color(0xFFFF00FF);
  static const Color green = Color(0xFF39FF14);
  static const Color red = Color(0xFFFF073A);
  static const Color yellow = Color(0xFFFFE700);

  // Game-specific colors
  static const Color mazeColor = cyan;
  static const Color pulseColor = magenta;
  static const Color stackColor = green;
  static const Color gridColor = yellow;
  static const Color pongColor = Color(0xFFFF6B35);

  // UI helper colors
  static const Color textDim = Color(0x99FFFFFF);
  static const Color textBright = Color(0xFFFFFFFF);
  static const Color cardFill = Color(0x0DFFFFFF);
  static const Color cardBorder = Color(0x33FFFFFF);

  /// Low-opacity version of the color for neon glow.
  static Color glowOuter(Color color) => color.withValues(alpha: 0.4);

  /// High-opacity version of the color for neon glow.
  static Color glowInner(Color color) => color.withValues(alpha: 0.8);

  /// Very low-opacity version for card backgrounds.
  static Color cardTint(Color color) => color.withValues(alpha: 0.05);
}
