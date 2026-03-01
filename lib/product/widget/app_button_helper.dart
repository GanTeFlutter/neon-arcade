import 'dart:ui';

import 'package:akillisletme/product/utils/button_feedback.dart';

/// Buton onPressed callback'ini feedback ile sarar.
VoidCallback? wrapWithFeedback(VoidCallback? onPressed) {
  if (onPressed == null) return null;
  return () {
    ButtonFeedback.trigger();
    onPressed();
  };
}
