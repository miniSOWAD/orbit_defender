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
            return Stack(
              children: [
                if (game.isBuyingPhase)
                  Positioned(
                    top: 108,
                    left: 20,
                    right: 20,
                    child: _BuyingBanner(game: game),
                  ),

                Positioned(
                  left: 18,
                  bottom: 18,
                  child: Row(
                    children: [
                      _RotateButton(
                        icon: Icons.rotate_left,
                        onDown: () => game.rotatingLeft = true,
                        onUp: () => game.rotatingLeft = false,
                      ),
                      const SizedBox(width: 12),
                      _RotateButton(
                        icon: Icons.rotate_right,
                        onDown: () => game.rotatingRight = true,
                        onUp: () => game.rotatingRight = false,
                      ),
                    ],
                  ),
                ),

                Positioned(
                  right: 18,
                  bottom: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _RocketSelector(game: game),
                      if (game.isBuyingPhase) ...[
                        const SizedBox(height: 8),
                        _HealButton(game: game),
                      ],
                      const SizedBox(height: 12),
                      _FireButton(game: game),
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

  const _BuyingBanner({
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.58),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.45),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            game.isFirstBuyingPhase
                ? 'PREPARE ROCKETS'
                : '+300 GOLD — SHOP OPEN',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'CLOSES IN ${game.buyingTimeLeft.ceil()}s',
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Tap rockets to buy. Buy ship HP if needed.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
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

  const _RotateButton({
    required this.icon,
    required this.onDown,
    required this.onUp,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onDown(),
      onTapUp: (_) => onUp(),
      onTapCancel: onUp,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.38),
          border: Border.all(
            color: Colors.white.withOpacity(0.24),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.12),
              blurRadius: 16,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class _FireButton extends StatelessWidget {
  final OrbitGuardGame game;

  const _FireButton({
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final canFire = game.state == GameState.playing &&
        game.rocketInventory[game.selectedRocketIndex] > 0;

    return GestureDetector(
      onTap: game.fireRocket,
      child: Container(
        width: 74,
        height: 74,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: canFire
                ? [
                    Colors.redAccent,
                    Colors.deepOrange,
                  ]
                : [
                    Colors.grey.shade700,
                    Colors.grey.shade800,
                  ],
          ),
          boxShadow: [
            if (canFire)
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.38),
                blurRadius: 22,
                spreadRadius: 2,
              ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.32),
            width: 1.6,
          ),
        ),
        child: Center(
          child: Text(
            game.isBuyingPhase ? 'SHOP' : 'FIRE',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _HealButton extends StatelessWidget {
  final OrbitGuardGame game;

  const _HealButton({
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final canBuy = game.gold >= GameConfig.shipHealCost &&
        game.shipHp < GameConfig.shipMaxHp;

    return GestureDetector(
      onTap: game.buyShipHp,
      child: Container(
        width: 292,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: canBuy
              ? Colors.greenAccent.withOpacity(0.16)
              : Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: canBuy
                ? Colors.greenAccent.withOpacity(0.65)
                : Colors.white.withOpacity(0.16),
          ),
        ),
        child: const Text(
          'BUY SHIP HP  +10  |  20G',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class _RocketSelector extends StatelessWidget {
  final OrbitGuardGame game;

  const _RocketSelector({
    required this.game,
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
            width: 62,
            margin: const EdgeInsets.only(left: 6),
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.cyanAccent.withOpacity(0.24)
                  : Colors.black.withOpacity(0.34),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? Colors.cyanAccent
                    : Colors.white.withOpacity(0.18),
              ),
              boxShadow: [
                if (selected)
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.18),
                    blurRadius: 12,
                  ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'R${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${rocket.damage.toInt()} DMG',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${rocket.cost}G',
                  style: TextStyle(
                    color: canBuy ? Colors.amberAccent : Colors.redAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'x$owned',
                  style: const TextStyle(
                    color: Colors.lightGreenAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
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