import 'package:akillisletme/feature/games/neon_pong/campaign/data/pong_worlds.dart';
import 'package:akillisletme/feature/games/neon_pong/campaign/level_select/state/pong_campaign_cubit.dart';
import 'package:akillisletme/feature/games/neon_pong/campaign/level_select/state/pong_campaign_state.dart';
import 'package:akillisletme/feature/games/neon_pong/campaign/level_select/widget/pong_level_tile.dart';
import 'package:akillisletme/feature/games/neon_pong/campaign/level_select/widget/pong_world_section.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_icon_button.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Pong campaign level selection screen.
class PongLevelSelectView extends StatelessWidget {
  const PongLevelSelectView({
    required this.onLevelSelected,
    required this.onBack,
    super.key,
  });

  final void Function(int levelId) onLevelSelected;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PongCampaignCubit(),
      child: Scaffold(
        backgroundColor: NeonColors.background,
        appBar: AppBar(
          leading: NeonIconButton(
            icon: Icons.arrow_back_rounded,
            color: NeonColors.textDim,
            onPressed: onBack,
          ),
          title: const NeonText(
            'KAMPANYA',
            color: NeonColors.pongColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<PongCampaignCubit, PongCampaignState>(
          builder: (context, state) {
            final cubit = context.read<PongCampaignCubit>();
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final world in PongWorld.values) ...[
                  PongWorldSection(
                    world: world,
                    children: List.generate(world.levelCount, (i) {
                      final id = world.startLevel + i;
                      final stars = cubit.starsFor(id);
                      final isUnlocked = cubit.isUnlocked(id);
                      final isBoss = id == world.bossLevelId;
                      return PongLevelTile(
                        levelId: id,
                        color: world.color,
                        stars: stars,
                        isUnlocked: isUnlocked,
                        isBoss: isBoss,
                        onTap: () => onLevelSelected(id),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                ],
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}
