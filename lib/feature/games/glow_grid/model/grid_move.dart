import 'package:flutter/foundation.dart';

/// A single move record (for undo).
@immutable
class GridMove {
  const GridMove({required this.row, required this.col});

  final int row;
  final int col;
}
