import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';

/// "NEON ARCADE" title with pulse animation.
class MenuTitle extends StatelessWidget {
  const MenuTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        NeonText(
          'NEON',
          color: NeonColors.cyan,
          fontSize: 36,
          fontWeight: FontWeight.w800,
          letterSpacing: 6,
          enablePulse: true,
        ),
        SizedBox(height: 2),
        NeonText(
          'ARCADE',
          color: NeonColors.magenta,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 10,
        ),
      ],
    );
  }
}
