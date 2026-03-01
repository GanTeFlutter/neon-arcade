import 'package:akillisletme/feature/games/glow_grid/model/grid_move.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'glow_grid_state.freezed.dart';

@freezed
abstract class GlowGridState with _$GlowGridState {
  const factory GlowGridState({
    /// Level ID.
    required int levelId,

    /// Grid size (NxN).
    required int size,

    /// Cell states: 1=on, 0=off, -1=locked.
    required List<int> cells,

    /// Move count.
    @Default(0) int moves,

    /// Undo stack.
    @Default([]) List<GridMove> undoStack,

    /// Remaining hint count.
    @Default(3) int hintsRemaining,

    /// Optimal move count (for star calculation).
    @Default(0) int optimalMoves,

    /// Whether diagonal effect is enabled.
    @Default(false) bool hasDiagonal,

    /// Whether the level is completed.
    @Default(false) bool isComplete,

    /// Stars earned (upon completion).
    @Default(0) int earnedStars,
  }) = _GlowGridState;
}
