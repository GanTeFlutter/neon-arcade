import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_icon_button.dart';
import 'package:flutter/material.dart';

/// Main menu bottom bar: settings button.
class MenuBottomBar extends StatelessWidget {
  const MenuBottomBar({
    required this.onSettings,
    super.key,
  });

  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          NeonIconButton(
            icon: Icons.settings_rounded,
            color: NeonColors.textDim,
            size: 28,
            onPressed: onSettings,
          ),
        ],
      ),
    );
  }
}
