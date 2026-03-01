import 'package:akillisletme/feature/games/neon_pong/model/pong_game_state.dart';

/// Combo streak tracking and multiplier calculation.
mixin PongComboMixin {
  PongGameState get game;

  /// Increment combo after a paddle bounce.
  void incrementCombo() {
    game.combo.increment();
  }

  /// Reset combo after a ball loss.
  void resetCombo() {
    game.combo.reset();
  }

  /// Calculate points with the current score multiplier.
  int calculateScore(int basePoints) {
    return basePoints * game.combo.multiplier;
  }
}
