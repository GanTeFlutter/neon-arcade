import 'dart:math';
import 'dart:ui' as ui;

import 'package:akillisletme/feature/games/neon_maze/model/maze_game_state.dart';
import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// CustomPainter that draws the maze + fog of war + player trail.
class MazeGamePainter extends CustomPainter {
  MazeGamePainter({required this.state, required this.color});

  final MazeGameState state;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (state.grid.isEmpty) return;

    final rows = state.rows;
    final cols = state.cols;
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    // Player center (pixels).
    final px = (state.playerCol + 0.5) * cellW;
    final py = (state.playerRow + 0.5) * cellH;

    // Trail.
    _drawTrail(canvas, cellW, cellH);

    // Walls.
    _drawWalls(canvas, size, cellW, cellH, rows, cols);

    // Exit.
    _drawExit(canvas, cellW, cellH);

    // Player.
    _drawPlayer(canvas, px, py, min(cellW, cellH) * 0.3);

    // Fog of war.
    _drawFog(canvas, size, px, py, cellW);
  }

  void _drawTrail(Canvas canvas, double cellW, double cellH) {
    for (var i = 0; i < state.trail.length; i++) {
      final t = state.trail[i];
      final alpha = (i / state.trail.length) * 0.25;
      final cx = (t.dx + 0.5) * cellW;
      final cy = (t.dy + 0.5) * cellH;
      final r = min(cellW, cellH) * 0.15;

      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }
  }

  void _drawWalls(
    Canvas canvas,
    Size size,
    double cellW,
    double cellH,
    int rows,
    int cols,
  ) {
    final wallPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final cell = state.grid[r][c];
        final x = c * cellW;
        final y = r * cellH;

        if (cell.top) {
          canvas.drawLine(Offset(x, y), Offset(x + cellW, y), wallPaint);
        }
        if (cell.left) {
          canvas.drawLine(Offset(x, y), Offset(x, y + cellH), wallPaint);
        }
        // Right edge (last column).
        if (c == cols - 1 && cell.right) {
          canvas.drawLine(
            Offset(x + cellW, y),
            Offset(x + cellW, y + cellH),
            wallPaint,
          );
        }
        // Bottom edge (last row).
        if (r == rows - 1 && cell.bottom) {
          canvas.drawLine(
            Offset(x, y + cellH),
            Offset(x + cellW, y + cellH),
            wallPaint,
          );
        }
      }
    }
  }

  void _drawExit(Canvas canvas, double cellW, double cellH) {
    final ex = (state.exitCol + 0.5) * cellW;
    final ey = (state.exitRow + 0.5) * cellH;
    final r = min(cellW, cellH) * 0.3;

    // Glow.
    final glow = Paint()
      ..color = NeonColors.green.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(Offset(ex, ey), r + 4, glow);

    // Exit marker.
    final paint = Paint()
      ..color = NeonColors.green.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(ex, ey), r, paint);

    final fill = Paint()..color = NeonColors.green.withValues(alpha: 0.15);
    canvas.drawCircle(Offset(ex, ey), r, fill);
  }

  void _drawPlayer(Canvas canvas, double px, double py, double r) {
    // Glow.
    final glow = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(px, py), r + 3, glow);

    // Player.
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(px, py), r, paint);

    // Inner glow.
    final inner = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset(px, py), r * 0.4, inner);
  }

  void _drawFog(Canvas canvas, Size size, double px, double py, double cellW) {
    final lightPixelRadius = state.lightRadius * cellW;

    // Radial gradient mask — transparent center, black edges.
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = ui.Gradient.radial(
      Offset(px, py),
      lightPixelRadius,
      [
        Colors.transparent,
        Colors.transparent,
        NeonColors.background.withValues(alpha: 0.85),
        NeonColors.background,
      ],
      [0, 0.5, 0.8, 1],
    );

    final fogPaint = Paint()..shader = gradient;
    canvas.drawRect(rect, fogPaint);
  }

  @override
  bool shouldRepaint(MazeGamePainter oldDelegate) => true;
}
