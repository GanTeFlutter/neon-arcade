import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/game/pause_menu_overlay.dart';
import 'package:akillisletme/product/widget/neon/neon_icon_button.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';

/// Common scaffold for all games.
/// Top bar: back button, game title, score, pause button.
/// Shows PauseMenuOverlay when the pause button is pressed.
class GameScaffold extends StatefulWidget {
  const GameScaffold({
    required this.title,
    required this.titleColor,
    required this.body,
    this.score,
    this.scoreWidget,
    this.onRestart,
    this.onHome,
    this.isPaused = false,
    this.onPauseChanged,
    super.key,
  });

  final String title;
  final Color titleColor;
  final Widget body;
  final int? score;
  final Widget? scoreWidget;
  final VoidCallback? onRestart;
  final VoidCallback? onHome;
  final bool isPaused;
  final ValueChanged<bool>? onPauseChanged;

  @override
  State<GameScaffold> createState() => _GameScaffoldState();
}

class _GameScaffoldState extends State<GameScaffold> {
  bool _showPause = false;

  void _togglePause() {
    setState(() => _showPause = !_showPause);
    widget.onPauseChanged?.call(_showPause);
  }

  void _resume() {
    setState(() => _showPause = false);
    widget.onPauseChanged?.call(false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (_showPause) {
            _resume();
          } else {
            _togglePause();
          }
        }
      },
      child: Scaffold(
        backgroundColor: NeonColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildTopBar(context),
                  Expanded(child: widget.body),
                ],
              ),
              if (_showPause)
                PauseMenuOverlay(
                  color: widget.titleColor,
                  onResume: _resume,
                  onRestart: () {
                    _resume();
                    widget.onRestart?.call();
                  },
                  onHome: widget.onHome,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          NeonIconButton(
            icon: Icons.arrow_back_rounded,
            color: NeonColors.textDim,
            onPressed: () {
              if (_showPause) {
                _resume();
              } else {
                _togglePause();
              }
            },
          ),
          Expanded(
            child: Center(
              child: NeonText(
                widget.title,
                color: widget.titleColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (widget.scoreWidget != null)
            widget.scoreWidget!
          else if (widget.score != null)
            Text(
              widget.score.toString(),
              style: TextStyle(
                fontFamily: AppFonts.neonScore,
                fontSize: 12,
                color: NeonColors.yellow,
                shadows: [
                  Shadow(
                    color: NeonColors.glowOuter(NeonColors.yellow),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          NeonIconButton(
            icon: Icons.pause_rounded,
            color: NeonColors.textDim,
            onPressed: _togglePause,
          ),
        ],
      ),
    );
  }
}
