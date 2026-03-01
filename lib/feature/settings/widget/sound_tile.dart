import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/init/language/locale_keys.g.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Sound effects toggle tile.
class SoundTile extends StatefulWidget {
  const SoundTile({super.key});

  @override
  State<SoundTile> createState() => _SoundTileState();
}

class _SoundTileState extends State<SoundTile> {
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = locator.sharedCache.isSoundEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      secondary: Icon(
        _enabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
        color: NeonColors.cyan,
      ),
      title: Text(LocaleKeys.settings_sound.tr()),
      value: _enabled,
      activeTrackColor: NeonColors.cyan.withValues(alpha: 0.4),
      activeThumbColor: NeonColors.cyan,
      onChanged: (value) {
        setState(() => _enabled = value);
        locator.sharedCache.setSoundEnabled(value: value);
      },
    );
  }
}
