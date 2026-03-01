import 'package:akillisletme/product/const/app_fonts.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Grid game toolbar: undo, move counter, reset.
class GridToolbar extends StatelessWidget {
  const GridToolbar({
    required this.moves,
    required this.canUndo,
    required this.onUndo,
    required this.onReset,
    super.key,
  });

  final int moves;
  final bool canUndo;
  final VoidCallback onUndo;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Undo
          IconButton(
            onPressed: canUndo ? onUndo : null,
            icon: Icon(
              Icons.undo_rounded,
              color: canUndo ? NeonColors.cyan : NeonColors.textDim,
            ),
          ),
          // Move counter
          Text(
            'HAMLE: $moves',
            style: const TextStyle(
              fontFamily: AppFonts.neonScore,
              fontSize: 10,
              color: NeonColors.textDim,
            ),
          ),
          // Reset
          IconButton(
            onPressed: onReset,
            icon: const Icon(
              Icons.refresh_rounded,
              color: NeonColors.yellow,
            ),
          ),
        ],
      ),
    );
  }
}
