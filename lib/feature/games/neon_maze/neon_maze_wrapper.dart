import 'package:akillisletme/feature/games/neon_maze/level_select/maze_level_select_view.dart';
import 'package:akillisletme/feature/games/neon_maze/neon_maze_view.dart';
import 'package:flutter/material.dart';

/// Neon Maze main wrapper.
/// Handles navigation between level select and game screen.
class NeonMazeWrapper extends StatefulWidget {
  const NeonMazeWrapper({super.key});

  @override
  State<NeonMazeWrapper> createState() => _NeonMazeWrapperState();
}

class _NeonMazeWrapperState extends State<NeonMazeWrapper> {
  int? _activeLevelId;

  void _startLevel(int levelId) {
    setState(() => _activeLevelId = levelId);
  }

  void _backToLevelSelect() {
    setState(() => _activeLevelId = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_activeLevelId == null) {
      return MazeLevelSelectView(onLevelSelected: _startLevel);
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _backToLevelSelect();
      },
      child: NeonMazeView(
        key: ValueKey(_activeLevelId),
        initialLevelId: _activeLevelId!,
      ),
    );
  }
}
