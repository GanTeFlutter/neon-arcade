import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/init/language/locale_keys.g.dart';
import 'package:akillisletme/product/widget/game/game_scaffold.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Henuz yapilmamis oyunlar icin placeholder ekrani.
class GamePlaceholderView extends StatelessWidget {
  const GamePlaceholderView({
    required this.title,
    required this.color,
    super.key,
  });

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: title,
      titleColor: color,
      onHome: () => Navigator.of(context).pop(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_rounded,
              color: color.withValues(alpha: 0.5),
              size: 64,
            ),
            const SizedBox(height: 24),
            NeonText(
              'COMING SOON',
              color: color,
              fontSize: 18,
              enablePulse: true,
            ),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.games_comingSoon.tr(),
              style: const TextStyle(
                fontFamily: AppFonts.body,
                fontSize: 14,
                color: NeonColors.textDim,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
