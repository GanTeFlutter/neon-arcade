/// Maze cell.
/// Each cell consists of 4 walls (top, right, bottom, left).
class MazeCell {
  MazeCell();

  bool top = true;
  bool right = true;
  bool bottom = true;
  bool left = true;

  /// Whether visited (used during maze generation).
  bool visited = false;
}
