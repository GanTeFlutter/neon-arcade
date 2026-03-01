import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:flutter/material.dart';

/// Virtual joystick control.
class ControlJoystick extends StatelessWidget {
  const ControlJoystick({
    required this.onMove,
    required this.color,
    super.key,
  });

  /// Direction: 0=up, 1=right, 2=down, 3=left.
  final void Function(int direction) onMove;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle.
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: NeonColors.surfaceDark.withValues(alpha: 0.5),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
              ),
            ),
          ),
          // Up.
          Positioned(
            top: 4,
            child: _JoystickButton(
              icon: Icons.keyboard_arrow_up_rounded,
              color: color,
              onTap: () => onMove(0),
            ),
          ),
          // Right.
          Positioned(
            right: 4,
            child: _JoystickButton(
              icon: Icons.keyboard_arrow_right_rounded,
              color: color,
              onTap: () => onMove(1),
            ),
          ),
          // Down.
          Positioned(
            bottom: 4,
            child: _JoystickButton(
              icon: Icons.keyboard_arrow_down_rounded,
              color: color,
              onTap: () => onMove(2),
            ),
          ),
          // Left.
          Positioned(
            left: 4,
            child: _JoystickButton(
              icon: Icons.keyboard_arrow_left_rounded,
              color: color,
              onTap: () => onMove(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _JoystickButton extends StatelessWidget {
  const _JoystickButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
