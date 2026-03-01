import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:flutter/material.dart';

/// Secondary button in neon style (text only, no border).
class NeonTextButton extends StatelessWidget {
  const NeonTextButton({
    required this.label,
    required this.color,
    this.onPressed,
    this.fontSize = 14,
    super.key,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed == null
          ? null
          : () {
              locator.vibrationService.light();
              onPressed!.call();
            },
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.neonDisplay,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: color.withValues(alpha: 0.8),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
