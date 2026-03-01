import 'package:akillisletme/feature/games/color_pulse/color_pulse_view.dart';
import 'package:akillisletme/feature/games/glow_grid/glow_grid_view.dart';
import 'package:akillisletme/feature/games/neon_maze/neon_maze_wrapper.dart';
import 'package:akillisletme/feature/games/neon_pong/neon_pong_wrapper.dart';
import 'package:akillisletme/feature/games/neon_stack/neon_stack_view.dart';
import 'package:akillisletme/feature/main_menu/main_menu_view.dart';
import 'package:akillisletme/feature/settings/about/about_view.dart';
import 'package:akillisletme/feature/settings/settings_view.dart';
import 'package:akillisletme/product/navigation/route_transitions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'app_router.g.dart';

// ── Main Menu ──────────────────────────────────────────────────
@TypedGoRoute<MainMenuRoute>(
  path: '/',
  routes: [
    TypedGoRoute<SettingsRoute>(
      path: 'settings',
      routes: [TypedGoRoute<AboutRoute>(path: 'about')],
    ),
  ],
)
class MainMenuRoute extends GoRouteData with $MainMenuRoute {
  const MainMenuRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadeTransition(key: state.pageKey, child: const MainMenuView());
  }
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideRightTransition(
      key: state.pageKey,
      child: const SettingsView(),
    );
  }
}

class AboutRoute extends GoRouteData with $AboutRoute {
  const AboutRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return slideRightTransition(
      key: state.pageKey,
      child: const AboutView(),
    );
  }
}

// ── Game Routes ────────────────────────────────────────────────
@TypedGoRoute<NeonStackRoute>(path: '/game/stack')
class NeonStackRoute extends GoRouteData with $NeonStackRoute {
  const NeonStackRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadeTransition(
      key: state.pageKey,
      child: const NeonStackView(),
    );
  }
}

@TypedGoRoute<GlowGridRoute>(path: '/game/grid')
class GlowGridRoute extends GoRouteData with $GlowGridRoute {
  const GlowGridRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadeTransition(
      key: state.pageKey,
      child: const GlowGridView(),
    );
  }
}

@TypedGoRoute<ColorPulseRoute>(path: '/game/pulse')
class ColorPulseRoute extends GoRouteData with $ColorPulseRoute {
  const ColorPulseRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadeTransition(
      key: state.pageKey,
      child: const ColorPulseView(),
    );
  }
}

@TypedGoRoute<NeonPongRoute>(path: '/game/pong')
class NeonPongRoute extends GoRouteData with $NeonPongRoute {
  const NeonPongRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadeTransition(
      key: state.pageKey,
      child: const NeonPongWrapper(),
    );
  }
}

@TypedGoRoute<NeonMazeRoute>(path: '/game/maze')
class NeonMazeRoute extends GoRouteData with $NeonMazeRoute {
  const NeonMazeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadeTransition(
      key: state.pageKey,
      child: const NeonMazeWrapper(),
    );
  }
}

// ── Router ──────────────────────────────────────────────────────
final class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: $appRoutes,
  );
}
