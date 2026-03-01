import 'dart:convert';

import 'package:akillisletme/product/service/service_locator.dart';

/// Neon Arcade score management.
/// Manages each game's high score and level progress.
class ScoreService {
  ScoreService._internal();
  static final ScoreService instance = ScoreService._internal();

  // ── Neon Stack ────────────────────────────────────────────
  int get stackHighScore => locator.sharedCache.highScoreStack;

  Future<bool> updateStackHighScore(int score) =>
      _updateHighScore(score, stackHighScore, locator.sharedCache.setHighScoreStack);

  // ── Color Pulse ───────────────────────────────────────────
  int get pulseHighScore => locator.sharedCache.highScorePulse;

  Future<bool> updatePulseHighScore(int score) =>
      _updateHighScore(score, pulseHighScore, locator.sharedCache.setHighScorePulse);

  // ── Neon Pong ─────────────────────────────────────────────
  int get pongHighScore => locator.sharedCache.highScorePong;

  Future<bool> updatePongHighScore(int score) =>
      _updateHighScore(score, pongHighScore, locator.sharedCache.setHighScorePong);

  // ── Glow Grid Level Progress ──────────────────────────────
  Map<int, int> get gridProgress =>
      _decodeProgress(locator.sharedCache.gridLevelProgress);

  int gridStars(int levelId) => gridProgress[levelId] ?? 0;

  Future<void> updateGridProgress(int levelId, int stars) =>
      _updateLevelProgress(gridProgress, levelId, stars, locator.sharedCache.setGridLevelProgress);

  // ── Neon Maze Level Progress ──────────────────────────────
  Map<int, int> get mazeProgress =>
      _decodeProgress(locator.sharedCache.mazeLevelProgress);

  int mazeStars(int levelId) => mazeProgress[levelId] ?? 0;

  Future<void> updateMazeProgress(int levelId, int stars) =>
      _updateLevelProgress(mazeProgress, levelId, stars, locator.sharedCache.setMazeLevelProgress);

  // ── Neon Pong Level Progress ─────────────────────────────
  Map<int, int> get pongProgress =>
      _decodeProgress(locator.sharedCache.pongLevelProgress);

  int pongStars(int levelId) => pongProgress[levelId] ?? 0;

  Future<void> updatePongProgress(int levelId, int stars) =>
      _updateLevelProgress(pongProgress, levelId, stars, locator.sharedCache.setPongLevelProgress);

  // ── Generic Helpers ──────────────────────────────────────
  Future<bool> _updateHighScore(
    int score,
    int current,
    Future<void> Function(int) setter,
  ) async {
    if (score > current) {
      await setter(score);
      return true;
    }
    return false;
  }

  Future<void> _updateLevelProgress(
    Map<int, int> progress,
    int levelId,
    int stars,
    Future<void> Function(String) setter,
  ) async {
    final current = progress[levelId] ?? 0;
    if (stars > current) {
      progress[levelId] = stars;
      await setter(_encodeProgress(progress));
    }
  }

  Map<int, int> _decodeProgress(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(int.parse(k), v as int));
  }

  String _encodeProgress(Map<int, int> progress) {
    final stringKeyMap = progress.map((k, v) => MapEntry(k.toString(), v));
    return jsonEncode(stringKeyMap);
  }
}
