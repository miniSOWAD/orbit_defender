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
          final screen = MediaQuery.of(context).size;
          final scale = (screen.height / 390).clamp(0.72, 1.0);

          return Padding(
            padding: EdgeInsets.fromLTRB(
              8 * scale,
              6 * scale,
              8 * scale,
              0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _StatBox(
                      scale: scale,
                      label: 'Earth',
                      value: '${game.earthHp.toInt()}/200',
                    ),
                    SizedBox(width: 5 * scale),
                    _StatBox(
                      scale: scale,
                      label: 'Ship',
                      value: '${game.shipHp.toInt()}/100',
                    ),
                    SizedBox(width: 5 * scale),
                    _StatBox(
                      scale: scale,
                      label: 'Gold',
                      value: '${game.gold}',
                    ),
                    SizedBox(width: 5 * scale),
                    _StatBox(
                      scale: scale,
                      label: 'Score',
                      value: '${game.score}',
                    ),
                    const Spacer(),
                    _PauseButton(
                      scale: scale,
                      game: game,
                    ),
                  ],
                ),
                SizedBox(height: 4 * scale),
                _MiniHealthBar(
                  scale: scale,
                  label: 'Earth',
                  value: game.earthHp / GameConfig.earthMaxHp,
                ),
                SizedBox(height: 3 * scale),
                _MiniHealthBar(
                  scale: scale,
                  label: 'Ship',
                  value: game.shipHp / GameConfig.shipMaxHp,
                ),
                SizedBox(height: 3 * scale),
                _ModeText(
                  scale: scale,
                  game: game,
                ),
                if (game.earthDyingWarning)
                  Text(
                    'EARTH DYING!',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 10 * scale,
                      letterSpacing: 1,
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
  final double scale;

  const _PauseButton({
    required this.game,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: game.pauseGame,
      child: Container(
        width: 42 * scale,
        height: 42 * scale,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(12 * scale),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
          ),
        ),
        child: Icon(
          Icons.pause,
          color: Colors.white,
          size: 23 * scale,
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final double scale;

  const _StatBox({
    required this.label,
    required this.value,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58 * scale,
      padding: EdgeInsets.symmetric(vertical: 5 * scale),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10 * scale),
        border: Border.all(
          color: Colors.white.withOpacity(0.16),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 8 * scale,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 9.5 * scale,
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
  final double scale;

  const _MiniHealthBar({
    required this.label,
    required this.value,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 34 * scale,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 8.5 * scale,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: clamped,
              minHeight: 5 * scale,
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
  final double scale;

  const _ModeText({
    required this.game,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    String text;

    if (game.state == GameState.buying) {
      text = 'SHOP: ${game.buyingTimeLeft.ceil()}s';
    } else if (game.state == GameState.earthDestroyed) {
      text = 'EARTH DESTROYED';
    } else {
      text = 'REWARD IN ${game.nextRewardTimeLeft.ceil()}s';
    }

    return Text(
      text,
      style: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.w800,
        fontSize: 9 * scale,
        letterSpacing: 0.5,
      ),
    );
  }
}