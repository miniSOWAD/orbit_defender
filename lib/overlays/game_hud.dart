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
        childBuilder: () {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _StatBox(label: 'Earth', value: '${game.earthHp.toInt()}/200'),
                    const SizedBox(width: 6),
                    _StatBox(label: 'Ship', value: '${game.shipHp.toInt()}/100'),
                    const SizedBox(width: 6),
                    _StatBox(label: 'Gold', value: '${game.gold}'),
                    const SizedBox(width: 6),
                    _StatBox(label: 'Score', value: '${game.score}'),
                    const Spacer(),
                    _PauseButton(game: game),
                  ],
                ),
                const SizedBox(height: 6),
                _MiniHealthBar(
                  label: 'Earth',
                  value: game.earthHp / GameConfig.earthMaxHp,
                ),
                const SizedBox(height: 4),
                _MiniHealthBar(
                  label: 'Ship',
                  value: game.shipHp / GameConfig.shipMaxHp,
                ),
                const SizedBox(height: 5),
                _ModeText(game: game),
                if (game.earthDyingWarning)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'WARNING: EARTH DYING!',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HudAutoRefresh extends StatefulWidget {
  final Widget Function() childBuilder;

  const _HudAutoRefresh({
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

class _PauseButton extends StatelessWidget {
  final OrbitGuardGame game;

  const _PauseButton({
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: game.pauseGame,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        child: const Icon(
          Icons.pause,
          color: Colors.white,
          size: 26,
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
      width: 64,
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.38),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: Colors.white.withOpacity(0.16),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniHealthBar extends StatelessWidget {
  final String label;
  final double value;

  const _MiniHealthBar({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 42,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: clamped,
              minHeight: 7,
              backgroundColor: Colors.white.withOpacity(0.13),
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

class _ModeText extends StatelessWidget {
  final OrbitGuardGame game;

  const _ModeText({
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    String text;

    if (game.state == GameState.buying) {
      text = 'BUYING PHASE: ${game.buyingTimeLeft.ceil()}s LEFT';
    } else if (game.state == GameState.earthDestroyed) {
      text = 'EARTH DESTROYED...';
    } else {
      text = 'NEXT REWARD IN ${game.nextRewardTimeLeft.ceil()}s';
    }

    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.w800,
        fontSize: 11,
        letterSpacing: 0.6,
      ),
    );
  }
}