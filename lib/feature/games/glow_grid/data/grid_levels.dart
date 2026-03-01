import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Glow Grid level definitions.
/// Each level: size, initial grid (1=on, 0=off, -1=locked),
/// optimal move count and star thresholds.
class GridLevel {
  const GridLevel({
    required this.id,
    required this.size,
    required this.grid,
    required this.optimalMoves,
    this.hasDiagonal = false,
  });

  final int id;
  final int size;

  /// Row-major flat list. 1=on, 0=off, -1=locked cell.
  final List<int> grid;

  /// Solution with minimum moves.
  final int optimalMoves;

  /// Whether diagonal effect is enabled (Tier 5).
  final bool hasDiagonal;

  /// Star thresholds: <=optimal=3, <=optimal+2=2, else=1
  int starsForMoves(int moves) {
    if (moves <= optimalMoves) return 3;
    if (moves <= optimalMoves + 2) return 2;
    return 1;
  }

  Color get tierColor {
    if (id <= 20) return NeonColors.cyan;
    if (id <= 40) return NeonColors.magenta;
    if (id <= 60) return NeonColors.green;
    if (id <= 80) return NeonColors.yellow;
    return NeonColors.red;
  }

  String get tierName {
    if (id <= 20) return 'EASY';
    if (id <= 40) return 'MEDIUM';
    if (id <= 60) return 'HARD';
    if (id <= 80) return 'EXPERT';
    return 'MASTER';
  }
}

/// 100 levels — algorithmically generated.
/// Tier 1 (1-20): 3x3, Tier 2 (21-40): 4x4, Tier 3 (41-60): 5x5
/// Tier 4 (61-80): 5x5+locked, Tier 5 (81-100): 6x6+locked+diagonal
final class GridLevels {
  GridLevels._();

  static final List<GridLevel> all = _generateAll();

  static GridLevel getLevel(int id) => all[id - 1];

  static List<GridLevel> _generateAll() {
    final levels = <GridLevel>[];

    // ── Tier 1: 3x3 (level 1-20) ──
    final tier1Patterns = <List<int>>[
      [0, 1, 0, 0, 0, 0, 0, 0, 0], // 1
      [0, 0, 0, 0, 1, 0, 0, 0, 0], // 2
      [1, 0, 0, 0, 0, 0, 0, 0, 0], // 3
      [1, 1, 0, 0, 0, 0, 0, 0, 0], // 4
      [0, 1, 0, 1, 0, 0, 0, 0, 0], // 5
      [1, 0, 1, 0, 0, 0, 0, 0, 0], // 6
      [0, 1, 0, 0, 1, 0, 0, 0, 0], // 7
      [1, 1, 1, 0, 0, 0, 0, 0, 0], // 8
      [0, 0, 0, 1, 1, 1, 0, 0, 0], // 9
      [1, 0, 0, 0, 1, 0, 0, 0, 1], // 10
      [0, 1, 0, 1, 1, 1, 0, 1, 0], // 11
      [1, 1, 0, 1, 0, 0, 0, 0, 0], // 12
      [1, 0, 1, 0, 1, 0, 1, 0, 1], // 13
      [0, 1, 1, 0, 1, 0, 0, 0, 1], // 14
      [1, 1, 0, 0, 1, 1, 0, 0, 0], // 15
      [1, 0, 1, 1, 0, 1, 0, 0, 0], // 16
      [0, 1, 0, 1, 0, 1, 0, 1, 0], // 17
      [1, 1, 1, 1, 0, 0, 0, 0, 0], // 18
      [1, 1, 0, 1, 1, 0, 0, 0, 0], // 19
      [1, 0, 1, 0, 0, 0, 1, 0, 1], // 20
    ];
    for (var i = 0; i < 20; i++) {
      levels.add(GridLevel(
        id: i + 1,
        size: 3,
        grid: tier1Patterns[i],
        optimalMoves: _countOnes(tier1Patterns[i]),
      ));
    }

    // ── Tier 2: 4x4 (level 21-40) ──
    final tier2Patterns = <List<int>>[
      [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
      [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
      [0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
      [0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0],
      [1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
      [0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0],
      [0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
      [1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    ];
    for (var i = 0; i < 20; i++) {
      levels.add(GridLevel(
        id: 21 + i,
        size: 4,
        grid: tier2Patterns[i],
        optimalMoves: _countOnes(tier2Patterns[i]),
      ));
    }

    // ── Tier 3: 5x5 (level 41-60) ──
    for (var i = 0; i < 20; i++) {
      final grid = _generateSolvable5x5(i + 41);
      levels.add(GridLevel(
        id: 41 + i,
        size: 5,
        grid: grid,
        optimalMoves: _countOnes(grid),
      ));
    }

    // ── Tier 4: 5x5 + locked (level 61-80) ──
    for (var i = 0; i < 20; i++) {
      final grid = _generateLocked5x5(i + 61);
      levels.add(GridLevel(
        id: 61 + i,
        size: 5,
        grid: grid,
        optimalMoves: _countOnes(grid.where((c) => c >= 0).toList()),
      ));
    }

    // ── Tier 5: 6x6 + locked + diagonal (level 81-100) ──
    for (var i = 0; i < 20; i++) {
      final grid = _generateDiagonal6x6(i + 81);
      levels.add(GridLevel(
        id: 81 + i,
        size: 6,
        grid: grid,
        optimalMoves: _countOnes(grid.where((c) => c >= 0).toList()),
        hasDiagonal: true,
      ));
    }

    return levels;
  }

  /// Generate a solvable 5x5 pattern (seed-based).
  static List<int> _generateSolvable5x5(int seed) {
    // Simple method: simulate taps on random cells.
    final grid = List.filled(25, 0);
    final taps = (seed % 4) + 2; // 2-5 tap
    for (var t = 0; t < taps; t++) {
      final pos = (seed * 7 + t * 13) % 25;
      _simulateTap5(grid, 5, pos ~/ 5, pos % 5);
    }
    return grid;
  }

  /// 5x5 + locked cells.
  static List<int> _generateLocked5x5(int seed) {
    final grid = _generateSolvable5x5(seed);
    // Add 2-3 locked cells (from the off ones).
    final lockCount = (seed % 2) + 2;
    var locked = 0;
    for (var i = 0; i < 25 && locked < lockCount; i++) {
      final idx = (seed * 3 + i * 7) % 25;
      if (grid[idx] == 0) {
        grid[idx] = -1;
        locked++;
      }
    }
    return grid;
  }

  /// 6x6 + locked + diagonal.
  static List<int> _generateDiagonal6x6(int seed) {
    final grid = List.filled(36, 0);
    final taps = (seed % 3) + 3;
    for (var t = 0; t < taps; t++) {
      final pos = (seed * 11 + t * 17) % 36;
      _simulateTap6Diag(grid, 6, pos ~/ 6, pos % 6);
    }
    // 2-4 locked cells.
    final lockCount = (seed % 3) + 2;
    var locked = 0;
    for (var i = 0; i < 36 && locked < lockCount; i++) {
      final idx = (seed * 5 + i * 11) % 36;
      if (grid[idx] == 0) {
        grid[idx] = -1;
        locked++;
      }
    }
    return grid;
  }

  static void _simulateTap5(List<int> grid, int size, int r, int c) {
    _toggle(grid, size, r, c);
    _toggle(grid, size, r - 1, c);
    _toggle(grid, size, r + 1, c);
    _toggle(grid, size, r, c - 1);
    _toggle(grid, size, r, c + 1);
  }

  static void _simulateTap6Diag(List<int> grid, int size, int r, int c) {
    _toggle(grid, size, r, c);
    _toggle(grid, size, r - 1, c);
    _toggle(grid, size, r + 1, c);
    _toggle(grid, size, r, c - 1);
    _toggle(grid, size, r, c + 1);
    _toggle(grid, size, r - 1, c - 1);
    _toggle(grid, size, r - 1, c + 1);
    _toggle(grid, size, r + 1, c - 1);
    _toggle(grid, size, r + 1, c + 1);
  }

  static void _toggle(List<int> grid, int size, int r, int c) {
    if (r < 0 || r >= size || c < 0 || c >= size) return;
    final idx = r * size + c;
    if (grid[idx] == -1) return; // Locked
    grid[idx] = grid[idx] == 0 ? 1 : 0;
  }

  static int _countOnes(List<int> grid) => grid.where((c) => c == 1).length;
}
