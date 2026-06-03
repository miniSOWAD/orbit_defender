import 'dart:async';

import 'package:flutter/material.dart';

import '../orbit_guard_game.dart';

class GameOverMenu extends StatefulWidget {
  final OrbitGuardGame game;

  const GameOverMenu({
    super.key,
    required this.game,
  });

  @override
  State<GameOverMenu> createState() => _GameOverMenuState();
}

class _GameOverMenuState extends State<GameOverMenu> {
  @override
  void initState() {
    super.initState();
    _returnToMenu();
  }

  Future<void> _returnToMenu() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    widget.game.finishGameOverAndReturnToMenu();
  }

  @override
  Widget build(BuildContext context) {
    final earthDestroyed = widget.game.earthHp <= 0;
    final shipDestroyed = widget.game.shipHp <= 0;

    String message = 'MISSION FAILED';

    if (earthDestroyed) {
      message = 'EARTH DESTROYED';
    } else if (shipDestroyed) {
      message = 'SHIP DESTROYED';
    }

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.78),
        child: Center(
          child: Container(
            width: 310,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF151020),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.redAccent.withOpacity(0.42),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.24),
                  blurRadius: 28,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'GAME OVER',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Score: ${widget.game.lastScore}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Survived: ${widget.game.lastSurvivedSeconds.toInt()}s',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Returning to main menu...',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}