import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../orbit_guard_game.dart';

class MainMenu extends StatelessWidget {
  final OrbitGuardGame game;

  const MainMenu({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Image.asset(
            'assets/images/menu.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.42),
          ),
          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.52),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.cyanAccent.withOpacity(0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.16),
                    blurRadius: 28,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'ORBIT DEFENDER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Protect Earth. Destroy meteors.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 22),

                  if (game.hasActiveRun) ...[
                    _MenuButton(
                      label: 'RESUME',
                      onTap: game.resumeExistingRun,
                    ),
                    const SizedBox(height: 10),
                  ],

                  _MenuButton(
                    label: 'NEW GAME',
                    onTap: game.startNewGame,
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: 'HELP',
                    onTap: () => _showHelp(context),
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: 'SCORE BOARD',
                    onTap: () => _showScoreBoard(context, game),
                  ),
                  const SizedBox(height: 10),
                  _MenuButton(
                    label: 'EXIT',
                    onTap: _exitGame,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF101426),
          title: const Text(
            'HELP',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Rotate the ship around Earth.\n\n'
            'Buy rockets during shop time.\n\n'
            'Fire only targets meteors in front of the ship.\n\n'
            'Meteors damage Earth if they reach it.\n\n'
            'Meteors damage the ship if they hit the ship.\n\n'
            'Survive 30 seconds to earn 300 gold.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showScoreBoard(BuildContext context, OrbitGuardGame game) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF101426),
          title: const Text(
            'SCORE BOARD',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Last Score: ${game.lastScore}\n'
            'Last Survival Time: ${game.lastSurvivedSeconds.toInt()}s',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _exitGame() {
    SystemNavigator.pop();
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00E5FF),
              Color(0xFF00FFA3),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.22),
              blurRadius: 16,
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 13,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}