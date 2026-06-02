import 'package:flutter/material.dart';

import '../constants.dart';
import '../orbit_guard_game.dart';

class GameHud extends StatelessWidget {
  final OrbitGuardGame game;

  const GameHud({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder<int>(
        valueListenable: _HudTicker(game),
        builder: (context, _, __) {
          return Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    _StatBox(
                      label: 'Earth',
                      value: '${game.earthHp.toInt()}/200',
                    ),
                    const SizedBox(width: 8),
                    _StatBox(
                      label: 'Ship',
                      value: '${game.shipHp.toInt()}/100',
                    ),
                    const SizedBox(width: 8),
                    _StatBox(
                      label: 'Gold',
                      value: '${game.gold}',
                    ),
                    const SizedBox(width: 8),
                    _StatBox(
                      label: 'Score',
                      value: '${game.score}',
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: game.pauseGame,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                        child: const Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _HealthBar(
                  label: 'Earth HP',
                  value: game.earthHp / GameConfig.earthMaxHp,
                ),
                const SizedBox(height: 6),
                _HealthBar(
                  label: 'Ship HP',
                  value: game.shipHp / GameConfig.shipMaxHp,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthBar extends StatelessWidget {
  final String label;
  final double value;

  const _HealthBar({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 68,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: clamped,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.14),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.lightGreenAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HudTicker extends ValueNotifier<int> {
  final OrbitGuardGame game;

  _HudTicker(this.game) : super(0) {
    _tick();
  }

  Future<void> _tick() async {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 150));
      value++;
    }
  }
}