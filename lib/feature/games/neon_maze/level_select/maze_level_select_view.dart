import 'package:akillisletme/feature/games/neon_maze/level_select/widget/maze_level_tile.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:akillisletme/product/widget/neon/neon_icon_button.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';

/// Neon Maze level selection screen.
/// 50 levels displayed in 5 tiers.
class MazeLevelSelectView extends StatelessWidget {
  const MazeLevelSelectView({required this.onLevelSelected, super.key});

  final void Function(int levelId) onLevelSelected;

  @override
  Widget build(BuildContext context) {
    final progress = locator.scoreService.mazeProgress;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: NeonIconButton(
          icon: Icons.arrow_back_rounded,
          color: NeonColors.textDim,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const NeonText(
          'NEON MAZE',
          color: NeonColors.mazeColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTier('EASY', 1, 10, NeonColors.cyan, progress),
          const SizedBox(height: 20),
          _buildTier('MEDIUM', 11, 20, NeonColors.magenta, progress),
          const SizedBox(height: 20),
          _buildTier('HARD', 21, 30, NeonColors.green, progress),
          const SizedBox(height: 20),
          _buildTier('EXPERT', 31, 40, NeonColors.yellow, progress),
          const SizedBox(height: 20),
          _buildTier('MASTER', 41, 50, NeonColors.red, progress),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTier(
    String name,
    int start,
    int end,
    Color color,
    Map<int, int> progress,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeonText(name, color: color, fontSize: 14, fontWeight: FontWeight.w600),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: end - start + 1,
          itemBuilder: (_, i) {
            final id = start + i;
            final stars = progress[id] ?? 0;
            final isUnlocked =
                id == 1 || (progress[id - 1] ?? 0) > 0 || stars > 0;

            return MazeLevelTile(
              levelId: id,
              color: color,
              stars: stars,
              isUnlocked: isUnlocked,
              onTap: () => onLevelSelected(id),
            );
          },
        ),
      ],
    );
  }
}
