import 'package:flutter/material.dart';

import '../orbit_guard_game.dart';

class MainMenu extends StatelessWidget {
  final OrbitGuardGame game;

  const MainMenu({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF050712),
      child: Center(
        child: Container(
          width: 330,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.18),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ORBIT GUARD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Protect Earth from meteor strikes.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 26),

              if (game.hasActiveRun) ...[
                _MenuButton(
                  label: 'RESUME',
                  onTap: game.resumeExistingRun,
                ),
                const SizedBox(height: 12),
              ],

              _MenuButton(
                label: 'NEW GAME',
                onTap: game.startNewGame,
              ),
              const SizedBox(height: 12),
              _MenuButton(
                label: 'HELP',
                onTap: () => _showHelp(context),
              ),
              const SizedBox(height: 12),
              _MenuButton(
                label: 'SCORE BOARD',
                onTap: () => _showScoreBoard(context, game),
              ),
              const SizedBox(height: 12),
              _MenuButton(
                label: 'EXIT',
                onTap: () => _showExitMessage(context),
              ),
            ],
          ),
        ),
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
            'Help',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Rotate the ship around Earth using the left and right buttons.\n\n'
            'Buy rockets during the shop phase.\n\n'
            'Fire rockets to destroy meteors before they hit Earth.\n\n'
            'Survive every 30 seconds to earn 300 gold.',
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
            'Score Board',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Last Score: ${game.score}\n'
            'Survived: ${game.survivedSeconds.toInt()}s',
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

  void _showExitMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Close the browser tab or app window to exit.'),
      ),
    );
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
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.cyanAccent,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}