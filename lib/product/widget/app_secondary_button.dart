import 'package:akillisletme/product/widget/app_button_helper.dart';
import 'package:flutter/material.dart';

/// Secondary action button — based on OutlinedButton.
/// For secondary actions like "go back, keep, cancel".
class AppSecondaryButton extends StatelessWidget {

  const AppSecondaryButton({
    required this.label, super.key,
    this.onPressed,
    this.icon,
    this.isExpanded = true,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final wrapped = wrapWithFeedback(onPressed);
    final cs = Theme.of(context).colorScheme;
    final button = icon != null
        ? OutlinedButton.icon(
            onPressed: wrapped,
            icon: Icon(icon, size: 20),
            label: _label(context),
            style: _style(cs),
          )
        : OutlinedButton(
            onPressed: wrapped,
            style: _style(cs),
            child: _label(context),
          );

    if (!isExpanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  Widget _label(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }

  ButtonStyle _style(ColorScheme cs) {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      side: BorderSide(color: cs.primary),
    );
  }
}
