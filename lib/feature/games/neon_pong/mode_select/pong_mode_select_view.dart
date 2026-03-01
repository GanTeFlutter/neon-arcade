import 'package:akillisletme/feature/games/neon_pong/mode_select/widget/pong_mode_card.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_level_config.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/init/language/locale_keys.g.dart';
import 'package:akillisletme/product/widget/neon/neon_icon_button.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Neon Pong mode selection screen.
class PongModeSelectView extends StatelessWidget {
  const PongModeSelectView({required this.onModeSelected, super.key});

  final void Function(PongMode mode) onModeSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonColors.background,
      appBar: AppBar(
        leading: NeonIconButton(
          icon: Icons.arrow_back_rounded,
          color: NeonColors.textDim,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const NeonText(
          'NEON PONG',
          color: NeonColors.pongColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PongModeCard(
              title: LocaleKeys.games_pongCampaign.tr(),
              description: LocaleKeys.games_pongCampaignDesc.tr(),
              icon: Icons.military_tech_rounded,
              color: NeonColors.cyan,
              onTap: () => onModeSelected(PongMode.campaign),
            ),
            const SizedBox(height: 16),
            PongModeCard(
              title: LocaleKeys.games_pongEndless.tr(),
              description: LocaleKeys.games_pongEndlessDesc.tr(),
              icon: Icons.all_inclusive_rounded,
              color: NeonColors.green,
              onTap: () => onModeSelected(PongMode.endless),
            ),
            const SizedBox(height: 16),
            PongModeCard(
              title: LocaleKeys.games_pongQuickMatch.tr(),
              description: LocaleKeys.games_pongQuickMatchDesc.tr(),
              icon: Icons.flash_on_rounded,
              color: NeonColors.yellow,
              onTap: () => onModeSelected(PongMode.quickMatch),
            ),
          ],
        ),
      ),
    );
  }
}
