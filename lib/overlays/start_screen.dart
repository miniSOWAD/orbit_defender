import 'dart:async';

import 'package:flutter/material.dart';

import '../orbit_guard_game.dart';

class StartScreen extends StatefulWidget {
  final OrbitGuardGame game;

  const StartScreen({
    super.key,
    required this.game,
  });

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    _goToMenu();
  }

  Future<void> _goToMenu() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    widget.game.overlays.remove('StartScreen');
    widget.game.overlays.add('MainMenu');
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/start.png',
        fit: BoxFit.cover,
      ),
    );
  }
}