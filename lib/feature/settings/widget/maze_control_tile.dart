import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/init/language/locale_keys.g.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Maze control type selection (drag / joystick).
class MazeControlTile extends StatefulWidget {
  const MazeControlTile({super.key});

  @override
  State<MazeControlTile> createState() => _MazeControlTileState();
}

class _MazeControlTileState extends State<MazeControlTile> {
  late String _controlType;

  @override
  void initState() {
    super.initState();
    _controlType = locator.sharedCache.mazeControlType;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.gamepad_rounded, color: NeonColors.green),
              const SizedBox(width: 16),
              Text(
                LocaleKeys.settings_mazeControl.tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'drag',
                  label: Text(
                    LocaleKeys.settings_mazeControlDrag.tr(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                ButtonSegment(
                  value: 'joystick',
                  label: Text(
                    LocaleKeys.settings_mazeControlJoystick.tr(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
              selected: {_controlType},
              onSelectionChanged: (selection) {
                final type = selection.first;
                setState(() => _controlType = type);
                locator.sharedCache.setMazeControlType(type);
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return NeonColors.green.withValues(alpha: 0.15);
                  }
                  return Colors.transparent;
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
