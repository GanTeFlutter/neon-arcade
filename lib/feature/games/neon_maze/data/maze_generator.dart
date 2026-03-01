import 'dart:math';

import 'package:akillisletme/feature/games/neon_maze/model/maze_cell.dart';

/// Maze generator using the Recursive Backtracker algorithm.
class MazeGenerator {
  MazeGenerator._();

  /// Generate a maze of [rows] x [cols] dimensions.
  static List<List<MazeCell>> generate(int rows, int cols, int seed) {
    final rng = Random(seed);
    final grid = List.generate(rows, (_) => List.generate(cols, (_) => MazeCell()));

    // Recursive Backtracker.
    final stack = <_Pos>[const _Pos(0, 0)];
    grid[0][0].visited = true;

    while (stack.isNotEmpty) {
      final current = stack.last;
      final neighbors = _unvisitedNeighbors(grid, current, rows, cols);

      if (neighbors.isEmpty) {
        stack.removeLast();
      } else {
        final next = neighbors[rng.nextInt(neighbors.length)];
        _removeWall(grid, current, next);
        grid[next.row][next.col].visited = true;
        stack.add(next);
      }
    }

    return grid;
  }

  static List<_Pos> _unvisitedNeighbors(
    List<List<MazeCell>> grid,
    _Pos pos,
    int rows,
    int cols,
  ) {
    final neighbors = <_Pos>[];
    final dirs = [
      _Pos(pos.row - 1, pos.col), // Up
      _Pos(pos.row + 1, pos.col), // Down
      _Pos(pos.row, pos.col - 1), // Left
      _Pos(pos.row, pos.col + 1), // Right
    ];

    for (final d in dirs) {
      if (d.row >= 0 &&
          d.row < rows &&
          d.col >= 0 &&
          d.col < cols &&
          !grid[d.row][d.col].visited) {
        neighbors.add(d);
      }
    }
    return neighbors;
  }

  static void _removeWall(
    List<List<MazeCell>> grid,
    _Pos current,
    _Pos next,
  ) {
    final dr = next.row - current.row;
    final dc = next.col - current.col;

    if (dr == -1) {
      // Up
      grid[current.row][current.col].top = false;
      grid[next.row][next.col].bottom = false;
    } else if (dr == 1) {
      // Down
      grid[current.row][current.col].bottom = false;
      grid[next.row][next.col].top = false;
    } else if (dc == -1) {
      // Left
      grid[current.row][current.col].left = false;
      grid[next.row][next.col].right = false;
    } else if (dc == 1) {
      // Right
      grid[current.row][current.col].right = false;
      grid[next.row][next.col].left = false;
    }
  }
}

class _Pos {
  const _Pos(this.row, this.col);
  final int row;
  final int col;
}
