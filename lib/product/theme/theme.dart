import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/theme/app_theme_colors.dart';
import 'package:akillisletme/product/theme/app_theme_variant.dart';
import 'package:akillisletme/product/theme/neon_game_colors.dart';
import 'package:flutter/material.dart';

part 'base/color_schemes.dart';
part 'parts/card_theme.dart';
part 'parts/button_theme.dart';
part 'parts/input_theme.dart';
part 'parts/appbar_theme.dart';
part 'parts/chip_theme.dart';
part 'parts/slider_theme.dart';
part 'base/dark_theme.dart';
part 'base/light_theme.dart';
part 'parts/text_theme.dart';

final class AppTheme {
  AppTheme._();
  static ThemeData darkTheme(AppThemeVariant variant) {
    if (variant == AppThemeVariant.neon) return _buildNeonDarkTheme();
    return _buildDarkTheme(_darkSchemeFor(variant));
  }

  static ThemeData lightTheme(AppThemeVariant variant) =>
      _buildLightTheme(_lightSchemeFor(variant));

  static ThemeData _buildNeonDarkTheme() {
    final cs = AppThemeVariant.neon.darkColorScheme;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      textTheme: _neonTextTheme,
      scaffoldBackgroundColor: NeonColors.background,
      appBarTheme: _appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: _darkCardTheme,
      inputDecorationTheme: _buildInputDecorationTheme(cs, Brightness.dark),
      elevatedButtonTheme: _buildElevatedButtonTheme(cs),
      filledButtonTheme: _buildFilledButtonTheme(cs),
      outlinedButtonTheme: _buildOutlinedButtonTheme(cs),
      chipTheme: _buildChipTheme(cs),
      sliderTheme: _buildSliderTheme(cs),
      dialogTheme: _dialogTheme,
      extensions: const [AppThemeColors.dark, NeonGameColors.neon],
    );
  }
}
