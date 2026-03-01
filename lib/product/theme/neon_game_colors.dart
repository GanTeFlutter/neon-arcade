import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Custom ThemeExtension for Neon Arcade.
/// Each game's neon color and glow variants are defined here.
class NeonGameColors extends ThemeExtension<NeonGameColors> {
  const NeonGameColors({
    required this.cyan,
    required this.magenta,
    required this.green,
    required this.red,
    required this.yellow,
    required this.pong,
    required this.background,
    required this.surfaceDark,
    required this.textDim,
  });

  final Color cyan;
  final Color magenta;
  final Color green;
  final Color red;
  final Color yellow;
  final Color pong;
  final Color background;
  final Color surfaceDark;
  final Color textDim;

  static const neon = NeonGameColors(
    cyan: NeonColors.cyan,
    magenta: NeonColors.magenta,
    green: NeonColors.green,
    red: NeonColors.red,
    yellow: NeonColors.yellow,
    pong: NeonColors.pongColor,
    background: NeonColors.background,
    surfaceDark: NeonColors.surfaceDark,
    textDim: NeonColors.textDim,
  );

  @override
  NeonGameColors copyWith({
    Color? cyan,
    Color? magenta,
    Color? green,
    Color? red,
    Color? yellow,
    Color? pong,
    Color? background,
    Color? surfaceDark,
    Color? textDim,
  }) =>
      NeonGameColors(
        cyan: cyan ?? this.cyan,
        magenta: magenta ?? this.magenta,
        green: green ?? this.green,
        red: red ?? this.red,
        yellow: yellow ?? this.yellow,
        pong: pong ?? this.pong,
        background: background ?? this.background,
        surfaceDark: surfaceDark ?? this.surfaceDark,
        textDim: textDim ?? this.textDim,
      );

  @override
  NeonGameColors lerp(covariant NeonGameColors? other, double t) {
    if (other is! NeonGameColors) return this;
    return NeonGameColors(
      cyan: Color.lerp(cyan, other.cyan, t)!,
      magenta: Color.lerp(magenta, other.magenta, t)!,
      green: Color.lerp(green, other.green, t)!,
      red: Color.lerp(red, other.red, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      pong: Color.lerp(pong, other.pong, t)!,
      background: Color.lerp(background, other.background, t)!,
      surfaceDark: Color.lerp(surfaceDark, other.surfaceDark, t)!,
      textDim: Color.lerp(textDim, other.textDim, t)!,
    );
  }
}

/// Shorthand access via `context.neonColors.cyan`.
extension NeonGameColorsExtension on BuildContext {
  NeonGameColors get neonColors =>
      Theme.of(this).extension<NeonGameColors>()!;
}
