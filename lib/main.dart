import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'orbit_guard_game.dart';
import 'overlays/control_overlay.dart';
import 'overlays/game_hud.dart';
import 'overlays/game_over_menu.dart';
import 'overlays/main_menu.dart';
import 'overlays/pause_menu.dart';

void main() {
  runApp(const OrbitGuardApp());
}

class OrbitGuardApp extends StatelessWidget {
  const OrbitGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = OrbitGuardGame();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget<OrbitGuardGame>(
          game: game,
          overlayBuilderMap: {
            'MainMenu': (context, game) => MainMenu(game: game),
            'GameHud': (context, game) => GameHud(game: game),
            'Controls': (context, game) => ControlOverlay(game: game),
            'PauseMenu': (context, game) => PauseMenu(game: game),
            'GameOverMenu': (context, game) => GameOverMenu(game: game),
          },
          initialActiveOverlays: const ['MainMenu'],
        ),
      ),
    );
  }
}