import 'package:akillisletme/feature/main_menu/main_menu_view_model.dart';
import 'package:akillisletme/feature/main_menu/widget/game_card.dart';
import 'package:akillisletme/feature/main_menu/widget/menu_bottom_bar.dart';
import 'package:akillisletme/feature/main_menu/widget/menu_title.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/init/language/locale_keys.g.dart';
import 'package:akillisletme/product/navigation/app_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends MainMenuViewModel {
  @override
  Widget build(BuildContext context) {
    final games = _gameList(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            const MenuTitle(),
            const SizedBox(height: 36),
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: games.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final game = games[i];
                  return AnimatedBuilder(
                    animation: cardAnimations[i],
                    builder: (_, child) {
                      final value = cardAnimations[i].value;
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: game,
                  );
                },
              ),
            ),
            MenuBottomBar(
              onSettings: () => const SettingsRoute().push<void>(context),
            ),
          ],
        ),
      ),
    );
  }

  List<GameCard> _gameList(BuildContext context) {
    return [
      GameCard(
        icon: Icons.layers_rounded,
        title: LocaleKeys.games_neonStack.tr(),
        description: LocaleKeys.games_neonStackDesc.tr(),
        color: NeonColors.stackColor,
        bestScore: bestStack,
        onTap: () async {
          await const NeonStackRoute().push<void>(context);
          refreshScores();
        },
      ),
      GameCard(
        icon: Icons.grid_on_rounded,
        title: LocaleKeys.games_glowGrid.tr(),
        description: LocaleKeys.games_glowGridDesc.tr(),
        color: NeonColors.gridColor,
        onTap: () async {
          await const GlowGridRoute().push<void>(context);
          refreshScores();
        },
      ),
      GameCard(
        icon: Icons.radio_button_checked_rounded,
        title: LocaleKeys.games_colorPulse.tr(),
        description: LocaleKeys.games_colorPulseDesc.tr(),
        color: NeonColors.pulseColor,
        bestScore: bestPulse,
        onTap: () async {
          await const ColorPulseRoute().push<void>(context);
          refreshScores();
        },
      ),
      GameCard(
        icon: Icons.sports_tennis_rounded,
        title: LocaleKeys.games_neonPong.tr(),
        description: LocaleKeys.games_neonPongDesc.tr(),
        color: NeonColors.pongColor,
        bestScore: bestPong,
        onTap: () async {
          await const NeonPongRoute().push<void>(context);
          refreshScores();
        },
      ),
      GameCard(
        icon: Icons.blur_on_rounded,
        title: LocaleKeys.games_neonMaze.tr(),
        description: LocaleKeys.games_neonMazeDesc.tr(),
        color: NeonColors.mazeColor,
        onTap: () async {
          await const NeonMazeRoute().push<void>(context);
          refreshScores();
        },
      ),
    ];
  }
}
