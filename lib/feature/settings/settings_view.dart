import 'package:akillisletme/feature/settings/widget/about_tile.dart';
import 'package:akillisletme/feature/settings/widget/background_animation_tile.dart';
import 'package:akillisletme/feature/settings/widget/contact_us_tile.dart';
import 'package:akillisletme/feature/settings/widget/language_tile.dart';
import 'package:akillisletme/feature/settings/widget/maze_control_tile.dart';
import 'package:akillisletme/feature/settings/widget/rate_app_tile.dart';
import 'package:akillisletme/feature/settings/widget/settings_section.dart';
import 'package:akillisletme/feature/settings/widget/sound_tile.dart';
import 'package:akillisletme/feature/settings/widget/vibration_tile.dart';
import 'package:akillisletme/product/init/language/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Trigger rebuild on language change

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(LocaleKeys.settings_title.tr())),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Game Settings
          SettingsSection(
            title: LocaleKeys.settings_gameSettings.tr(),
            children: const [SoundTile(), VibrationTile(), MazeControlTile()],
          ),
          const SizedBox(height: 16),
          // Appearance
          SettingsSection(
            title: LocaleKeys.settings_appearance.tr(),
            children: const [LanguageTile(), BackgroundAnimationTile()],
          ),
          const SizedBox(height: 16),
          // Support
          SettingsSection(
            title: LocaleKeys.settings_support.tr(),
            children: const [ContactUsTile(), RateAppTile()],
          ),
          const SizedBox(height: 16),
          // About
          SettingsSection(
            title: LocaleKeys.settings_aboutTitle.tr(),
            children: const [AboutTile()],
          ),
        ],
      ),
    );
  }
}
