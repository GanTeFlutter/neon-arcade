import 'package:akillisletme/product/const/neon_colors.dart';
import 'package:akillisletme/product/widget/neon/neon_background.dart';
import 'package:flutter/material.dart';

/// MaterialApp builder — global neon background + overlay layer.
class AppBuilder {
  const AppBuilder._();

  static Widget call(BuildContext context, Widget? child) {
    return ColoredBox(
      color: NeonColors.background,
      child: Stack(
        children: [
          const Positioned.fill(
            child: RepaintBoundary(child: NeonBackground()),
          ),
          Positioned.fill(child: child!),
        ],
      ),
    );
  }
}
