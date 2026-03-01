import 'package:flutter/services.dart';

/// Button tap feedback — system sound + haptic.
class ButtonFeedback {
  ButtonFeedback._();

  static void trigger() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }
}
