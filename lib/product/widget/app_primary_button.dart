import 'package:akillisletme/product/widget/app_button_helper.dart';
import 'package:flutter/material.dart';


/// Primary action button — based on FilledButton.
/// For primary actions like "start, submit, continue, update".
class AppPrimaryButton extends StatelessWidget {

  const AppPrimaryButton({
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
    final button = icon != null
        ? FilledButton.icon(
            onPressed: wrapped,
            icon: Icon(icon, size: 20),
            label: _label(context),
            style: _style(),
          )
        : FilledButton(
            onPressed: wrapped,
            style: _style(),
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

  ButtonStyle _style() {
    return FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
