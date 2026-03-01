import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Page transition that slides in from right to left.
/// New page slides in with a fade in, background animation is preserved.
Page<dynamic> slideRightTransition({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // New page: slide + fade in
      final offsetAnimation = Tween(
        begin: const Offset(0.3, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);

      final fadeIn = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );

      // Previous page: fade out
      final fadeOut = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeIn,
        ),
      );

      return FadeTransition(
        opacity: fadeOut,
        child: FadeTransition(
          opacity: fadeIn,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        ),
      );
    },
  );
}

/// Smooth fade transition.
/// Previous page fades out, new page fades in — sequential intervals prevent overlap.
Page<dynamic> fadeTransition({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // New page: fade in during the second half (wait 0.0–0.4, fade in 0.4–1.0)
      final fadeIn = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.4, 1, curve: Curves.easeOut),
      );

      // Previous page: fade out
      final fadeOut = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0, 0.6, curve: Curves.easeIn),
        ),
      );

      return FadeTransition(
        opacity: fadeOut,
        child: FadeTransition(
          opacity: fadeIn,
          child: child,
        ),
      );
    },
  );
}
