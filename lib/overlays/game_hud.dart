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
      child: _HudAutoRefresh(
        game: game,
        childBuilder: () {
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
                const SizedBox(height: 8),
                _ModeBar(game: game),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HudAutoRefresh extends StatefulWidget {
  final OrbitGuardGame game;
  final Widget Function() childBuilder;

  const _HudAutoRefresh({
    required this.game,
    required this.childBuilder,
  });

  @override
  State<_HudAutoRefresh> createState() => _HudAutoRefreshState();
}

class _HudAutoRefreshState extends State<_HudAutoRefresh> {
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.childBuilder();
  }
}

class _ModeBar extends StatelessWidget {
  final OrbitGuardGame game;

  const _ModeBar({
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final isBuying = game.isBuyingPhase;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isBuying
            ? Colors.cyanAccent.withOpacity(0.16)
            : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isBuying
              ? Colors.cyanAccent.withOpacity(0.45)
              : Colors.white.withOpacity(0.16),
        ),
      ),
      child: Text(
        isBuying
            ? 'BUYING PHASE — ${game.buyingTimeLeft.ceil()}s LEFT'
            : 'SURVIVE — NEXT REWARD IN ${(GameConfig.survivalRewardInterval - game.survivedSeconds % GameConfig.survivalRewardInterval).ceil()}s',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isBuying ? Colors.cyanAccent : Colors.white70,
          fontWeight: FontWeight.w900,
          fontSize: 12,
          letterSpacing: 0.8,
        ),
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
              valueColor: AlwaysStoppedAnimation<Color>(
                clamped > 0.35
                    ? Colors.lightGreenAccent
                    : Colors.redAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}