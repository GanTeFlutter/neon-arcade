import 'package:akillisletme/feature/games/neon_pong/model/pong_level_config.dart';
import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/init/language/locale_keys.g.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:akillisletme/product/widget/neon/neon_glow_box.dart';
import 'package:akillisletme/product/widget/neon/neon_icon_button.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Quick match difficulty selection.
class PongQuickMatchSetup extends StatelessWidget {
  const PongQuickMatchSetup({
    required this.onStart,
    required this.onBack,
    super.key,
  });

  final void Function(QuickMatchDifficulty) onStart;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonColors.background,
      appBar: AppBar(
        leading: NeonIconButton(
          icon: Icons.arrow_back_rounded,
          color: NeonColors.textDim,
          onPressed: onBack,
        ),
        title: NeonText(
          LocaleKeys.games_pongQuickMatch.tr(),
          color: NeonColors.yellow,
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
            NeonText(
              LocaleKeys.games_pongDifficultySelect.tr(),
              color: NeonColors.textDim,
              fontSize: 12,
            ),
            const SizedBox(height: 24),
            _DifficultyCard(
              title: LocaleKeys.games_pongEasy.tr(),
              description: LocaleKeys.games_pongEasyDesc.tr(),
              color: NeonColors.green,
              onTap: () => onStart(QuickMatchDifficulty.easy),
            ),
            const SizedBox(height: 12),
            _DifficultyCard(
              title: LocaleKeys.games_pongMedium.tr(),
              description: LocaleKeys.games_pongMediumDesc.tr(),
              color: NeonColors.yellow,
              onTap: () => onStart(QuickMatchDifficulty.medium),
            ),
            const SizedBox(height: 12),
            _DifficultyCard(
              title: LocaleKeys.games_pongHard.tr(),
              description: LocaleKeys.games_pongHardDesc.tr(),
              color: NeonColors.red,
              onTap: () => onStart(QuickMatchDifficulty.hard),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  const _DifficultyCard({
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator.audioService.playBlip();
        locator.vibrationService.light();
        onTap();
      },
      child: NeonGlowBox(
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.neonDisplay,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: color,
                      letterSpacing: 1,
                      shadows: [
                        Shadow(
                          color: NeonColors.glowOuter(color),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: AppFonts.neonDisplay,
                      fontSize: 10,
                      color: NeonColors.textDim,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.play_arrow_rounded,
              color: color.withValues(alpha: 0.6),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
