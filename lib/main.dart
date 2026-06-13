import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'orbit_guard_game.dart';
import 'overlays/control_overlay.dart';
import 'overlays/game_hud.dart';
import 'overlays/game_over_menu.dart';
import 'overlays/main_menu.dart';
import 'overlays/pause_menu.dart';
import 'overlays/start_screen.dart';

const String kGameFontFamily = 'Orbitron';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  runApp(const OrbitGuardApp());
}

class OrbitGuardApp extends StatelessWidget {
  const OrbitGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = OrbitGuardGame();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orbit Defender',
      theme: ThemeData(
        fontFamily: kGameFontFamily,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: kGameFontFamily),
          displayMedium: TextStyle(fontFamily: kGameFontFamily),
          displaySmall: TextStyle(fontFamily: kGameFontFamily),
          headlineLarge: TextStyle(fontFamily: kGameFontFamily),
          headlineMedium: TextStyle(fontFamily: kGameFontFamily),
          headlineSmall: TextStyle(fontFamily: kGameFontFamily),
          titleLarge: TextStyle(fontFamily: kGameFontFamily),
          titleMedium: TextStyle(fontFamily: kGameFontFamily),
          titleSmall: TextStyle(fontFamily: kGameFontFamily),
          bodyLarge: TextStyle(fontFamily: kGameFontFamily),
          bodyMedium: TextStyle(fontFamily: kGameFontFamily),
          bodySmall: TextStyle(fontFamily: kGameFontFamily),
          labelLarge: TextStyle(fontFamily: kGameFontFamily),
          labelMedium: TextStyle(fontFamily: kGameFontFamily),
          labelSmall: TextStyle(fontFamily: kGameFontFamily),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: GameWidget<OrbitGuardGame>(
          game: game,
          overlayBuilderMap: {
            'StartScreen': (context, game) => StartScreen(game: game),
            'MainMenu': (context, game) => MainMenu(game: game),
            'GameHud': (context, game) => GameHud(game: game),
            'Controls': (context, game) => ControlOverlay(game: game),
            'PauseMenu': (context, game) => PauseMenu(game: game),
            'GameOverMenu': (context, game) => GameOverMenu(game: game),
          },
          initialActiveOverlays: const ['StartScreen'],
        ),
      ),
    );
  }
}