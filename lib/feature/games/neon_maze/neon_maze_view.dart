import 'package:akillisletme/feature/games/neon_maze/data/maze_levels.dart';
import 'package:akillisletme/feature/games/neon_maze/neon_maze_view_model.dart';
import 'package:akillisletme/feature/games/neon_maze/painter/maze_game_painter.dart';
import 'package:akillisletme/feature/games/neon_maze/widget/control_joystick.dart';
import 'package:akillisletme/feature/games/neon_maze/widget/maze_complete_overlay.dart';
import 'package:akillisletme/feature/games/neon_maze/widget/maze_game_over_overlay.dart';
import 'package:akillisletme/feature/games/neon_maze/widget/maze_timer.dart';
import 'package:akillisletme/product/widget/game/game_scaffold.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';

class NeonMazeView extends StatefulWidget {
  const NeonMazeView({required this.initialLevelId, super.key});

  final int initialLevelId;

  @override
  State<NeonMazeView> createState() => _NeonMazeViewState();
}

class _NeonMazeViewState extends NeonMazeViewModel {
  @override
  Widget build(BuildContext context) {
    final level = MazeLevels.getLevel(game.levelId);
    final color = level.tierColor;
    final useJoystick = controlType == 'joystick';

    return GameScaffold(
      title: 'LEVEL ${game.levelId}',
      titleColor: color,
      onRestart: restartLevel,
      onHome: () => Navigator.of(context).pop(),
      onPauseChanged: (paused) {
        if (paused) {
          pauseGame();
        } else {
          resumeGame();
        }
      },
      body: Stack(
        children: [
          // Main game content.
          Column(
            children: [
              // Timer.
              MazeTimer(
                timeLeft: game.timeLeft,
                totalTime: game.totalTime,
                color: color,
              ),

              // Maze.
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!game.hasStarted) startGame();
                  },
                  onPanUpdate: useJoystick ? null : onPanUpdate,
                  onPanEnd: useJoystick ? null : (_) => onPanEnd(),
                  behavior: HitTestBehavior.opaque,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final mazeSize =
                          constraints.maxWidth < constraints.maxHeight
                              ? constraints.maxWidth
                              : constraints.maxHeight;
                      cellSize = mazeSize / game.cols;

                      return Center(
                        child: SizedBox(
                          width: mazeSize,
                          height: mazeSize * (game.rows / game.cols),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: MazeGamePainter(
                                    state: game,
                                    color: color,
                                  ),
                                ),
                              ),
                              if (!game.hasStarted)
                                Center(
                                  child: NeonText(
                                    useJoystick
                                        ? 'USE JOYSTICK'
                                        : 'SWIPE TO START',
                                    color: color,
                                    fontSize: 14,
                                    enablePulse: true,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Joystick or empty space.
              if (useJoystick &&
                  game.hasStarted &&
                  !game.isGameOver &&
                  !game.isComplete)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ControlJoystick(
                    onMove: onJoystickMove,
                    color: color,
                  ),
                )
              else
                const SizedBox(height: 16),
            ],
          ),

          // Level Complete overlay.
          if (game.isComplete)
            MazeCompleteOverlay(
              levelId: game.levelId,
              stars: game.earnedStars,
              timeLeft: game.timeLeft,
              color: color,
              hasNext: game.levelId < 50,
              onNextLevel: () => loadLevel(game.levelId + 1),
              onRetry: restartLevel,
              onLevelSelect: () => Navigator.of(context).pop(),
            ),

          // Game Over (time expired).
          if (game.isGameOver)
            MazeGameOverOverlay(
              color: color,
              onRetry: restartLevel,
              onLevelSelect: () => Navigator.of(context).pop(),
            ),
        ],
      ),
    );
  }

}
