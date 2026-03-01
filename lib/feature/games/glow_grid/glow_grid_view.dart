import 'package:akillisletme/feature/games/glow_grid/level_select/level_select_view.dart';
import 'package:akillisletme/feature/games/glow_grid/state/glow_grid_cubit.dart';
import 'package:akillisletme/feature/games/glow_grid/widget/glow_grid_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Glow Grid main view.
/// Switches between level select and game screen.
class GlowGridView extends StatefulWidget {
  const GlowGridView({super.key});

  @override
  State<GlowGridView> createState() => _GlowGridViewState();
}

class _GlowGridViewState extends State<GlowGridView> {
  GlowGridCubit? _cubit;

  void _startLevel(int levelId) {
    setState(() {
      _cubit?.close();
      _cubit = GlowGridCubit(levelId: levelId);
    });
  }

  void _backToLevelSelect() {
    setState(() {
      _cubit?.close();
      _cubit = null;
    });
  }

  @override
  void dispose() {
    _cubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cubit == null) {
      return GlowGridLevelSelectView(onLevelSelected: _startLevel);
    }

    return BlocProvider.value(
      value: _cubit!,
      child: GlowGridGameScreen(
        onBackToSelect: _backToLevelSelect,
        onNextLevel: _startLevel,
      ),
    );
  }
}
