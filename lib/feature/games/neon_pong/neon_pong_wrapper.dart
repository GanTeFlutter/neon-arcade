import 'package:akillisletme/feature/games/neon_pong/campaign/level_select/pong_level_select_view.dart';
import 'package:akillisletme/feature/games/neon_pong/game/neon_pong_view.dart';
import 'package:akillisletme/feature/games/neon_pong/mode_select/pong_mode_select_view.dart';
import 'package:akillisletme/feature/games/neon_pong/model/pong_level_config.dart';
import 'package:akillisletme/feature/games/neon_pong/widget/pong_quick_match_setup.dart';
import 'package:flutter/material.dart';

/// Neon Pong main wrapper.
/// Handles transitions between mode select → level select → game screen.
class NeonPongWrapper extends StatefulWidget {
  const NeonPongWrapper({super.key});

  @override
  State<NeonPongWrapper> createState() => _NeonPongWrapperState();
}

enum _PongScreen { modeSelect, levelSelect, quickMatchSetup, game }

class _NeonPongWrapperState extends State<NeonPongWrapper> {
  _PongScreen _screen = _PongScreen.modeSelect;
  PongMode _selectedMode = PongMode.campaign;
  int? _activeLevelId;
  QuickMatchDifficulty _quickDifficulty = QuickMatchDifficulty.medium;

  void _onModeSelected(PongMode mode) {
    setState(() {
      _selectedMode = mode;
      switch (mode) {
        case PongMode.campaign:
          _screen = _PongScreen.levelSelect;
        case PongMode.endless:
          _screen = _PongScreen.game;
          _activeLevelId = null;
        case PongMode.quickMatch:
          _screen = _PongScreen.quickMatchSetup;
      }
    });
  }

  void _onLevelSelected(int levelId) {
    setState(() {
      _activeLevelId = levelId;
      _screen = _PongScreen.game;
    });
  }

  void _onQuickMatchStart(QuickMatchDifficulty difficulty) {
    setState(() {
      _quickDifficulty = difficulty;
      _screen = _PongScreen.game;
    });
  }

  void _backToModeSelect() {
    setState(() {
      _screen = _PongScreen.modeSelect;
      _activeLevelId = null;
    });
  }

  void _backToLevelSelect() {
    setState(() {
      _screen = _PongScreen.levelSelect;
      _activeLevelId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_screen) {
      case _PongScreen.modeSelect:
        return PongModeSelectView(onModeSelected: _onModeSelected);

      case _PongScreen.levelSelect:
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _backToModeSelect();
          },
          child: PongLevelSelectView(
            onLevelSelected: _onLevelSelected,
            onBack: _backToModeSelect,
          ),
        );

      case _PongScreen.quickMatchSetup:
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _backToModeSelect();
          },
          child: PongQuickMatchSetup(
            onStart: _onQuickMatchStart,
            onBack: _backToModeSelect,
          ),
        );

      case _PongScreen.game:
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) {
              if (_selectedMode == PongMode.campaign) {
                _backToLevelSelect();
              } else {
                _backToModeSelect();
              }
            }
          },
          child: NeonPongView(
            key: ValueKey('${_selectedMode.name}_${_activeLevelId}_$_quickDifficulty'),
            mode: _selectedMode,
            levelId: _activeLevelId,
            quickMatchDifficulty: _quickDifficulty,
            onBackToLevelSelect: _backToLevelSelect,
            onBackToModeSelect: _backToModeSelect,
          ),
        );
    }
  }
}
