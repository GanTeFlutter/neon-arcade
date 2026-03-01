import 'dart:async';

import 'package:akillisletme/feature/games/glow_grid/data/grid_levels.dart';
import 'package:akillisletme/feature/games/glow_grid/model/grid_move.dart';
import 'package:akillisletme/feature/games/glow_grid/state/glow_grid_state.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Glow Grid game logic.
class GlowGridCubit extends Cubit<GlowGridState> {
  GlowGridCubit({required int levelId})
      : super(_initialState(levelId));

  static GlowGridState _initialState(int levelId) {
    final level = GridLevels.getLevel(levelId);
    return GlowGridState(
      levelId: levelId,
      size: level.size,
      cells: List<int>.from(level.grid),
      optimalMoves: level.optimalMoves,
      hasDiagonal: level.hasDiagonal,
    );
  }

  /// Tap a cell.
  void tapCell(int row, int col) {
    if (state.isComplete) return;

    final cells = List<int>.from(state.cells);
    final size = state.size;

    // Cannot tap a locked cell.
    if (cells[row * size + col] == -1) return;

    // Toggle: self + 4 neighbors (+ diagonals in tier 5).
    _toggle(cells, size, row, col);
    _toggle(cells, size, row - 1, col);
    _toggle(cells, size, row + 1, col);
    _toggle(cells, size, row, col - 1);
    _toggle(cells, size, row, col + 1);

    if (state.hasDiagonal) {
      _toggle(cells, size, row - 1, col - 1);
      _toggle(cells, size, row - 1, col + 1);
      _toggle(cells, size, row + 1, col - 1);
      _toggle(cells, size, row + 1, col + 1);
    }

    final moves = state.moves + 1;
    final undoStack = [...state.undoStack, GridMove(row: row, col: col)];

    unawaited(locator.audioService.playBlip());
    unawaited(locator.vibrationService.light());

    // Completion check: all cells are 0 or -1.
    final isComplete = cells.every((c) => c <= 0);

    if (isComplete) {
      final level = GridLevels.getLevel(state.levelId);
      final stars = level.starsForMoves(moves);
      unawaited(locator.audioService.playSynth());
      unawaited(locator.vibrationService.medium());
      unawaited(
        locator.scoreService.updateGridProgress(state.levelId, stars),
      );

      emit(state.copyWith(
        cells: cells,
        moves: moves,
        undoStack: undoStack,
        isComplete: true,
        earnedStars: stars,
      ));
    } else {
      emit(state.copyWith(
        cells: cells,
        moves: moves,
        undoStack: undoStack,
      ));
    }
  }

  /// Undo last move.
  void undo() {
    if (state.undoStack.isEmpty || state.isComplete) return;

    final lastMove = state.undoStack.last;
    final cells = List<int>.from(state.cells);
    final size = state.size;

    // Repeat the same tap (toggle is idempotent).
    _toggle(cells, size, lastMove.row, lastMove.col);
    _toggle(cells, size, lastMove.row - 1, lastMove.col);
    _toggle(cells, size, lastMove.row + 1, lastMove.col);
    _toggle(cells, size, lastMove.row, lastMove.col - 1);
    _toggle(cells, size, lastMove.row, lastMove.col + 1);

    if (state.hasDiagonal) {
      _toggle(cells, size, lastMove.row - 1, lastMove.col - 1);
      _toggle(cells, size, lastMove.row - 1, lastMove.col + 1);
      _toggle(cells, size, lastMove.row + 1, lastMove.col - 1);
      _toggle(cells, size, lastMove.row + 1, lastMove.col + 1);
    }

    final undoStack = List<GridMove>.from(state.undoStack)..removeLast();

    emit(state.copyWith(
      cells: cells,
      moves: state.moves - 1,
      undoStack: undoStack,
    ));
  }

  /// Reset the level.
  void resetLevel() {
    emit(_initialState(state.levelId));
  }

  /// Load a new level.
  void loadLevel(int levelId) {
    emit(_initialState(levelId));
  }

  void _toggle(List<int> cells, int size, int r, int c) {
    if (r < 0 || r >= size || c < 0 || c >= size) return;
    final idx = r * size + c;
    if (cells[idx] == -1) return; // Locked
    cells[idx] = cells[idx] == 0 ? 1 : 0;
  }
}
