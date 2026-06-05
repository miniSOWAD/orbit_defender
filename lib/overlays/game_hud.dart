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
          final scale = (screen.height / 390).clamp(0.68, 1.0);

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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      ],
                    ),

                    SizedBox(width: 10 * scale),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 2 * scale),
                        child: Column(
                          children: [
                            _TopCompactHealthBar(
                              scale: scale,
                              label: 'Earth',
                              value: game.earthHp / GameConfig.earthMaxHp,
                            ),
                            SizedBox(height: 5 * scale),
                            _TopCompactHealthBar(
                              scale: scale,
                              label: 'Ship',
                              value: game.shipHp / GameConfig.shipMaxHp,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: 8 * scale),

                    _PauseButton(
                      scale: scale,
                      game: game,
                    ),
                  ],
                ),

                SizedBox(height: 6 * scale),

                _ModeText(
                  scale: scale,
                  game: game,
                ),

                if (game.earthDyingWarning)
                  Padding(
                    padding: EdgeInsets.only(top: 2 * scale),
                    child: Text(
                      'EARTH DYING!',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w900,
                        fontSize: 10 * scale,
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
          size: 22 * scale,
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

class _TopCompactHealthBar extends StatelessWidget {
  final String label;
  final double value;
  final double scale;

  const _TopCompactHealthBar({
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
              fontSize: 8.2 * scale,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 7 * scale,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: clamped,
                minHeight: 7 * scale,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  clamped > 0.35
                      ? Colors.lightGreenAccent
                      : Colors.redAccent,
                ),
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