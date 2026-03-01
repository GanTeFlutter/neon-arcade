import 'package:akillisletme/feature/main_menu/main_menu_view.dart';
import 'package:akillisletme/product/service/service_locator.dart';
import 'package:flutter/material.dart';

/// State management for MainMenuView.
/// Staggered card animations + score loading.
abstract class MainMenuViewModel extends State<MainMenuView>
    with SingleTickerProviderStateMixin {
  late final AnimationController staggerController;
  late final List<Animation<double>> cardAnimations;
  static const _cardCount = 5;

  int bestStack = 0;
  int bestPulse = 0;
  int bestPong = 0;

  @override
  void initState() {
    super.initState();
    _loadScores();

    staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    cardAnimations = List.generate(_cardCount, (i) {
      final start = i * 0.15;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: staggerController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      );
    });

    staggerController.forward();
  }

  void _loadScores() {
    final scoreService = locator.scoreService;
    bestStack = scoreService.stackHighScore;
    bestPulse = scoreService.pulseHighScore;
    bestPong = scoreService.pongHighScore;
  }

  void refreshScores() {
    _loadScores();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    staggerController.dispose();
    super.dispose();
  }
}
