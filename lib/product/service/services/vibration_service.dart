import 'package:akillisletme/product/service/service_locator.dart';
import 'package:flutter/services.dart';

/// Neon Arcade vibration service.
/// Can be toggled on/off from settings.
class VibrationService {
  VibrationService._internal();
  static final VibrationService instance = VibrationService._internal();

  bool get _enabled => locator.sharedCache.isVibrationEnabled;

  /// Light vibration (tap, normal interaction)
  Future<void> light() async {
    if (!_enabled) return;
    await HapticFeedback.lightImpact();
  }

  /// Medium vibration (score, achievement)
  Future<void> medium() async {
    if (!_enabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// Heavy vibration (error, game over)
  Future<void> heavy() async {
    if (!_enabled) return;
    await HapticFeedback.heavyImpact();
  }

  /// Selection tick (toggle, selection)
  Future<void> selection() async {
    if (!_enabled) return;
    await HapticFeedback.selectionClick();
  }
}
