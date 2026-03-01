import 'package:akillisletme/product/theme/app_theme_variant.dart';
import 'package:akillisletme/product/theme/state/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Neon Arcade: theme is always neon dark.
/// setVariant/setThemeMode are kept for existing widgets (no-op).
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  // ignore: no-op — theme does not change in Neon Arcade
  void setVariant(AppThemeVariant variant) {}

  // ignore: no-op — always dark mode in Neon Arcade
  void setThemeMode(ThemeMode mode) {}
}
