import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/init/language/locale_keys.g.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Vibration toggle tile.
class VibrationTile extends StatefulWidget {
  const VibrationTile({super.key});

  @override
  State<VibrationTile> createState() => _VibrationTileState();
}

class _VibrationTileState extends State<VibrationTile> {
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = locator.sharedCache.isVibrationEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      secondary: Icon(
        _enabled ? Icons.vibration_rounded : Icons.phone_android_rounded,
        color: NeonColors.magenta,
      ),
      title: Text(LocaleKeys.settings_vibration.tr()),
      value: _enabled,
      activeTrackColor: NeonColors.magenta.withValues(alpha: 0.4),
      activeThumbColor: NeonColors.magenta,
      onChanged: (value) {
        setState(() => _enabled = value);
        locator.sharedCache.setVibrationEnabled(value: value);
      },
    );
  }
}
