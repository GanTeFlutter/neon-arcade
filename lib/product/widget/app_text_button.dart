import 'package:akillisletme/product/widget/app_button_helper.dart';
import 'package:flutter/material.dart';


/// Minimal/text button — based on TextButton.
/// For lightweight actions like "clear, delete".
class AppTextButton extends StatelessWidget {

  const AppTextButton({
    required this.label, super.key,
    this.onPressed,
    this.color,
  });
  final String label;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: wrapWithFeedback(onPressed),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
            ),
      ),
    );
  }
}
