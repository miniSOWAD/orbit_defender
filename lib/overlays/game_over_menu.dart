import 'package:flutter/material.dart';

import '../orbit_guard_game.dart';

class GameOverMenu extends StatelessWidget {
  final OrbitGuardGame game;

  const GameOverMenu({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final earthDestroyed = game.earthHp <= 0;

    return Container(
      color: Colors.black.withOpacity(0.72),
      child: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF151020),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.redAccent.withOpacity(0.35),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'GAME OVER',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                earthDestroyed ? 'Earth was destroyed.' : 'Your ship was destroyed.',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Score: ${game.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              Text(
                'Survived: ${game.survivedSeconds.toInt()}s',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              _Button(
                label: 'PLAY AGAIN',
                onTap: game.startNewGame,
              ),
              const SizedBox(height: 12),
              _Button(
                label: 'MAIN MENU',
                onTap: game.goToMainMenu,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _Button({
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
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}