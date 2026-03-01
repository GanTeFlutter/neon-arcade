import 'package:akillisletme/product/cache/shared_operation/base_shared_operation.dart';
import 'package:akillisletme/product/cache/shared_operation/shared_keys.dart';
import 'package:flutter/material.dart';

final class SharedCache {
  SharedCache._internal();
  static final SharedCache instance = SharedCache._internal();

  late final BaseSharedOperation _sharedOperation;

  Future<void> init() async {
    _sharedOperation = SharedOperation();
    await _sharedOperation.init();
  }

  Future<void> clear() async {
    await _sharedOperation.clear();
  }

  // ── Generic access ─────────────────────────────────────────
  T? getValue<T>(SharedKeys key) => _sharedOperation.getValue<T>(key);

  Future<void> setValue<T>(SharedKeys key, T value) async {
    await _sharedOperation.setValue<T>(key, value);
  }

  // ── Background Animation ──────────────────────────────────
  bool get isBackgroundAnimationEnabled =>
      _sharedOperation.getValue<bool>(SharedKeys.backgroundAnimation) ?? true;

  Future<void> setBackgroundAnimation({required bool enabled}) async {
    await _sharedOperation.setValue(SharedKeys.backgroundAnimation, enabled);
  }

  // ── Theme ──────────────────────────────────────────────────
  ThemeMode get themeMode {
    final key = _sharedOperation.getValue<String>(SharedKeys.theme);
    if (key == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (m) => m.name == key,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _sharedOperation.setValue<String>(SharedKeys.theme, mode.name);
  }

  // ── Sound ──────────────────────────────────────────────────
  bool get isSoundEnabled =>
      getValue<bool>(SharedKeys.soundEnabled) ?? true;

  Future<void> setSoundEnabled({required bool value}) async {
    await setValue(SharedKeys.soundEnabled, value);
  }

  // ── Vibration ──────────────────────────────────────────────
  bool get isVibrationEnabled =>
      getValue<bool>(SharedKeys.vibrationEnabled) ?? true;

  Future<void> setVibrationEnabled({required bool value}) async {
    await setValue(SharedKeys.vibrationEnabled, value);
  }

  // ── Maze Control Type ──────────────────────────────────────
  String get mazeControlType =>
      getValue<String>(SharedKeys.mazeControlType) ?? 'drag';

  Future<void> setMazeControlType(String type) async {
    await setValue<String>(SharedKeys.mazeControlType, type);
  }

  // ── High Scores ────────────────────────────────────────────
  int get highScoreStack =>
      getValue<int>(SharedKeys.highScoreStack) ?? 0;

  Future<void> setHighScoreStack(int score) async {
    await setValue<int>(SharedKeys.highScoreStack, score);
  }

  int get highScorePulse =>
      getValue<int>(SharedKeys.highScorePulse) ?? 0;

  Future<void> setHighScorePulse(int score) async {
    await setValue<int>(SharedKeys.highScorePulse, score);
  }

  int get highScorePong =>
      getValue<int>(SharedKeys.highScorePong) ?? 0;

  Future<void> setHighScorePong(int score) async {
    await setValue<int>(SharedKeys.highScorePong, score);
  }

  // ── Level Progress (JSON string: {"1":3,"2":2,...}) ────────
  String get gridLevelProgress =>
      getValue<String>(SharedKeys.gridLevelProgress) ?? '{}';

  Future<void> setGridLevelProgress(String json) async {
    await setValue<String>(SharedKeys.gridLevelProgress, json);
  }

  String get mazeLevelProgress =>
      getValue<String>(SharedKeys.mazeLevelProgress) ?? '{}';

  Future<void> setMazeLevelProgress(String json) async {
    await setValue<String>(SharedKeys.mazeLevelProgress, json);
  }

  // ── Pong Level Progress ──────────────────────────────────────
  String get pongLevelProgress =>
      getValue<String>(SharedKeys.pongLevelProgress) ?? '{}';

  Future<void> setPongLevelProgress(String json) async {
    await setValue<String>(SharedKeys.pongLevelProgress, json);
  }
}
