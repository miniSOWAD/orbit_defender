import 'package:flutter/material.dart';

import '../constants.dart';
import '../orbit_guard_game.dart';

class ControlOverlay extends StatelessWidget {
  final OrbitGuardGame game;

  const ControlOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SafeArea(
        child: _ControlAutoRefresh(
          childBuilder: () {
            final screen = MediaQuery.of(context).size;
            final scale = (screen.height / 390).clamp(0.68, 0.95);

            return Stack(
              children: [
                if (game.isBuyingPhase)
                  Positioned(
                    top: 76 * scale,
                    left: 160 * scale,
                    right: 160 * scale,
                    child: _BuyingBanner(
                      scale: scale,
                      game: game,
                    ),
                  ),

                Positioned(
                  left: 14 * scale,
                  bottom: 12 * scale,
                  child: Row(
                    children: [
                      _RotateButton(
                        scale: scale,
                        icon: Icons.rotate_left,
                        onDown: () => game.rotatingLeft = true,
                        onUp: () => game.rotatingLeft = false,
                      ),
                      SizedBox(width: 10 * scale),
                      _RotateButton(
                        scale: scale,
                        icon: Icons.rotate_right,
                        onDown: () => game.rotatingRight = true,
                        onUp: () => game.rotatingRight = false,
                      ),
                    ],
                  ),
                ),

                Positioned(
                  right: 14 * scale,
                  bottom: 12 * scale,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _RocketSelector(
                        scale: scale,
                        game: game,
                      ),
                      if (game.isBuyingPhase) ...[
                        SizedBox(height: 6 * scale),
                        _HealButton(
                          scale: scale,
                          game: game,
                        ),
                      ],
                      SizedBox(height: 8 * scale),
                      _FireButton(
                        scale: scale,
                        game: game,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ControlAutoRefresh extends StatefulWidget {
  final Widget Function() childBuilder;

  const _ControlAutoRefresh({
    required this.childBuilder,
  });

  @override
  State<_ControlAutoRefresh> createState() => _ControlAutoRefreshState();
}

class _ControlAutoRefreshState extends State<_ControlAutoRefresh> {
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 120));
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.childBuilder();
  }
}

class _BuyingBanner extends StatelessWidget {
  final OrbitGuardGame game;
  final double scale;

  const _BuyingBanner({
    required this.game,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * scale,
        vertical: 6 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.42),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            game.isFirstBuyingPhase ? 'SHOP OPEN' : '+300 GOLD',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 10 * scale,
              letterSpacing: 1,
            ),
          ),
          Text(
            '${game.buyingTimeLeft.ceil()}s LEFT',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.w900,
              fontSize: 10 * scale,
            ),
          ),
        ],
      ),
    );
  }
}

class _RotateButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onDown;
  final VoidCallback onUp;
  final double scale;

  const _RotateButton({
    required this.icon,
    required this.onDown,
    required this.onUp,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onDown(),
      onTapUp: (_) => onUp(),
      onTapCancel: onUp,
      child: Container(
        width: 48 * scale,
        height: 48 * scale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.36),
          border: Border.all(
            color: Colors.white.withOpacity(0.24),
            width: 1.2,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 25 * scale,
        ),
      ),
    );
  }
}

class _FireButton extends StatelessWidget {
  final OrbitGuardGame game;
  final double scale;

  const _FireButton({
    required this.game,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final canFire = game.state == GameState.playing &&
        game.rocketInventory[game.selectedRocketIndex] > 0;

    return GestureDetector(
      onTap: game.fireRocket,
      child: Container(
        width: 62 * scale,
        height: 62 * scale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: canFire
                ? const [
                    Colors.redAccent,
                    Colors.deepOrange,
                  ]
                : [
                    Colors.grey.shade700,
                    Colors.grey.shade800,
                  ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.4,
          ),
        ),
        child: Center(
          child: Text(
            game.isBuyingPhase ? 'SHOP' : 'FIRE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 11 * scale,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}

class _HealButton extends StatelessWidget {
  final OrbitGuardGame game;
  final double scale;

  const _HealButton({
    required this.game,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final canBuy = game.gold >= GameConfig.shipHealCost &&
        game.shipHp < GameConfig.shipMaxHp;

    return GestureDetector(
      onTap: game.buyShipHp,
      child: Container(
        width: 220 * scale,
        padding: EdgeInsets.symmetric(
          horizontal: 8 * scale,
          vertical: 5 * scale,
        ),
        decoration: BoxDecoration(
          color: canBuy
              ? Colors.greenAccent.withOpacity(0.16)
              : Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(10 * scale),
          border: Border.all(
            color: canBuy
                ? Colors.greenAccent.withOpacity(0.65)
                : Colors.white.withOpacity(0.16),
          ),
        ),
        child: Text(
          '+10 SHIP HP  |  20G',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.w900,
            fontSize: 9 * scale,
            letterSpacing: 0.7,
          ),
        ),
      ),
    );
  }
}

class _RocketSelector extends StatelessWidget {
  final OrbitGuardGame game;
  final double scale;

  const _RocketSelector({
    required this.game,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(GameData.rockets.length, (index) {
        final rocket = GameData.rockets[index];
        final selected = game.selectedRocketIndex == index;
        final owned = game.rocketInventory[index];
        final canBuy = game.gold >= rocket.cost;

        return GestureDetector(
          onTap: () {
            if (game.isBuyingPhase) {
              game.buyRocket(index);
            } else {
              game.selectRocket(index);
            }
          },
          onLongPress: () {
            game.selectRocket(index);
          },
          child: Container(
            width: 50 * scale,
            margin: EdgeInsets.only(left: 5 * scale),
            padding: EdgeInsets.symmetric(
              horizontal: 4 * scale,
              vertical: 5 * scale,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.cyanAccent.withOpacity(0.24)
                  : Colors.black.withOpacity(0.34),
              borderRadius: BorderRadius.circular(10 * scale),
              border: Border.all(
                color: selected
                    ? Colors.cyanAccent
                    : Colors.white.withOpacity(0.18),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'R${index + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 9.5 * scale,
                  ),
                ),
                Text(
                  '${rocket.damage.toInt()}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 7.5 * scale,
                  ),
                ),
                Text(
                  '${rocket.cost}G',
                  style: TextStyle(
                    color: canBuy ? Colors.amberAccent : Colors.redAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 8.5 * scale,
                  ),
                ),
                Text(
                  'x$owned',
                  style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 9 * scale,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}