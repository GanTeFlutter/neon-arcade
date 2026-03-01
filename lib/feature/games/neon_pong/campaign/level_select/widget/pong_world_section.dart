import 'package:akillisletme/feature/games/neon_pong/campaign/data/pong_worlds.dart';
import 'package:akillisletme/product/widget/neon/neon_text.dart';
import 'package:flutter/material.dart';

/// World section: title + level grid.
class PongWorldSection extends StatelessWidget {
  const PongWorldSection({
    required this.world,
    required this.children,
    super.key,
  });

  final PongWorld world;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeonText(
          world.displayName,
          color: world.color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 6,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: children,
        ),
      ],
    );
  }
}
