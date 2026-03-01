import 'package:akillisletme/feature/games/glow_grid/data/grid_levels.dart';
import 'package:akillisletme/feature/games/glow_grid/state/glow_grid_cubit.dart';
import 'package:akillisletme/feature/games/glow_grid/state/glow_grid_state.dart';
import 'package:akillisletme/feature/games/glow_grid/widget/grid_cell.dart';
import 'package:akillisletme/feature/games/glow_grid/widget/grid_toolbar.dart';
import 'package:akillisletme/feature/games/glow_grid/widget/level_complete_overlay.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_icon_button.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Glow Grid oyun ekranı.
class GlowGridGameScreen extends StatelessWidget {
  const GlowGridGameScreen({
    required this.onBackToSelect,
    required this.onNextLevel,
    super.key,
  });

  final VoidCallback onBackToSelect;
  final void Function(int nextId) onNextLevel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlowGridCubit, GlowGridState>(
      builder: (context, state) {
        final cubit = context.read<GlowGridCubit>();
        final level = GridLevels.getLevel(state.levelId);
        final color = level.tierColor;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Top bar
                    _buildTopBar(context, state, color),
                    // Toolbar
                    GridToolbar(
                      moves: state.moves,
                      canUndo: state.undoStack.isNotEmpty,
                      onUndo: cubit.undo,
                      onReset: cubit.resetLevel,
                    ),
                    // Grid
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: state.size,
                              ),
                              itemCount: state.size * state.size,
                              itemBuilder: (_, i) {
                                final row = i ~/ state.size;
                                final col = i % state.size;
                                final cellValue = state.cells[i];
                                return GridCell(
                                  isOn: cellValue == 1,
                                  isLocked: cellValue == -1,
                                  color: color,
                                  onTap: () => cubit.tapCell(row, col),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Level Complete overlay
                if (state.isComplete)
                  LevelCompleteOverlay(
                    stars: state.earnedStars,
                    moves: state.moves,
                    color: color,
                    hasNext: state.levelId < 100,
                    onNext: state.levelId < 100
                        ? () => onNextLevel(state.levelId + 1)
                        : null,
                    onRetry: cubit.resetLevel,
                    onHome: onBackToSelect,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    GlowGridState state,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          NeonIconButton(
            icon: Icons.arrow_back_rounded,
            color: NeonColors.textDim,
            onPressed: onBackToSelect,
          ),
          Expanded(
            child: Center(
              child: NeonText(
                'LEVEL ${state.levelId}',
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
