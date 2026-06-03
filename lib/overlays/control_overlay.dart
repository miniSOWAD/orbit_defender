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
                    top: 118,
                    left: 16,
                    right: 16,
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
                      const SizedBox(width: 16),
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
                      const SizedBox(height: 14),
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
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.45),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            game.isFirstBuyingPhase
                ? 'Prepare Rockets'
                : 'Reward +300 Gold — Buy Rockets',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Shop closes in ${game.buyingTimeLeft.ceil()}s',
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Tap rocket cards to buy. FIRE unlocks after buying phase.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
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
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.13),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 38,
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
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: canFire
              ? Colors.redAccent.withOpacity(0.9)
              : Colors.grey.withOpacity(0.62),
          boxShadow: [
            if (canFire)
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.4),
                blurRadius: 24,
                spreadRadius: 4,
              ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.38),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            game.isBuyingPhase ? 'SHOP' : 'FIRE',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 1.1,
            ),
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
            width: 68,
            margin: const EdgeInsets.only(left: 7),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.cyanAccent.withOpacity(0.28)
                  : Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? Colors.cyanAccent
                    : Colors.white.withOpacity(0.22),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'R${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${rocket.damage.toInt()} DMG',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${rocket.cost}G',
                  style: TextStyle(
                    color: canBuy ? Colors.amberAccent : Colors.redAccent,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'x$owned',
                  style: const TextStyle(
                    color: Colors.lightGreenAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
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