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
                if (game.showRewardAlert)
                  Center(
                    child: _RewardCenterAlert(scale: scale),
                  ),

                if (game.isBuyingPhase && !game.showRewardAlert)
                  Positioned(
                    top: 74 * scale,
                    left: 170 * scale,
                    right: 170 * scale,
                    child: _BuyingBanner(
                      scale: scale,
                      game: game,
                    ),
                  ),

                Positioned(
                  left: 18 * scale,
                  bottom: 16 * scale,
                  child: Row(
                    children: [
                      _RotateButton(
                        scale: scale,
                        icon: Icons.rotate_left,
                        onDown: () => game.rotatingLeft = true,
                        onUp: () => game.rotatingLeft = false,
                      ),
                      SizedBox(width: 14 * scale),
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

class _RewardCenterAlert extends StatelessWidget {
  final double scale;

  const _RewardCenterAlert({
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310 * scale,
      padding: EdgeInsets.symmetric(
        horizontal: 18 * scale,
        vertical: 18 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.82),
        borderRadius: BorderRadius.circular(22 * scale),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.35),
            blurRadius: 28 * scale,
            spreadRadius: 3 * scale,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '+300 GOLD',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.w900,
              fontSize: 25 * scale,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 8 * scale),
          Text(
            'BUY ROCKETS NOW',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.w900,
              fontSize: 18 * scale,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 6 * scale),
          Text(
            'SHOP OPEN FOR 12 SECONDS',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w700,
              fontSize: 10 * scale,
              letterSpacing: 0.8,
            ),
          ),
        ],
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
      await Future.delayed(const Duration(milliseconds: 100));
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
    final title = game.isFirstBuyingPhase ? 'ROCKET SHOP OPEN' : 'BUY ROCKETS NOW';

    final subtitle = game.isFirstBuyingPhase
        ? '${game.buyingTimeLeft.ceil()}s to prepare'
        : '+300 GOLD | ${game.buyingTimeLeft.ceil()}s left';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * scale,
        vertical: 7 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.68),
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.16),
            blurRadius: 18 * scale,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 10.5 * scale,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 2 * scale),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.w900,
              fontSize: 9.5 * scale,
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
        width: 64 * scale,
        height: 64 * scale,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.06),
          border: Border.all(
            color: Colors.white.withOpacity(0.24),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.08),
              blurRadius: 18 * scale,
              spreadRadius: 1 * scale,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white.withOpacity(0.82),
          size: 34 * scale,
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
            color: canBuy ? Colors.greenAccent : Colors.white38,
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

        final isBuying = game.isBuyingPhase;
        final canBuy = game.gold >= rocket.cost;
        final canFire = game.state == GameState.playing && owned > 0;

        return GestureDetector(
          onTap: () {
            if (isBuying) {
              game.buyRocket(index);
            } else {
              game.fireRocketOfType(index);
            }
          },
          onLongPress: () {
            game.selectRocket(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            width: 56 * scale,
            margin: EdgeInsets.only(left: 5 * scale),
            padding: EdgeInsets.symmetric(
              horizontal: 4 * scale,
              vertical: 5 * scale,
            ),
            decoration: BoxDecoration(
              color: _cardColor(
                isBuying: isBuying,
                selected: selected,
                canBuy: canBuy,
                canFire: canFire,
              ),
              borderRadius: BorderRadius.circular(10 * scale),
              border: Border.all(
                color: _borderColor(
                  isBuying: isBuying,
                  selected: selected,
                  canBuy: canBuy,
                  canFire: canFire,
                ),
              ),
              boxShadow: [
                if (!isBuying && canFire)
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.18),
                    blurRadius: 12 * scale,
                  ),
                if (isBuying && selected)
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.18),
                    blurRadius: 12 * scale,
                  ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  isBuying ? 'BUY R${index + 1}' : 'FIRE R${index + 1}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 7.1 * scale,
                  ),
                ),
                SizedBox(height: 1 * scale),
                Text(
                  '${rocket.damage.toInt()} DMG',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 6.7 * scale,
                  ),
                ),
                Text(
                  isBuying ? '${rocket.cost}G' : 'x$owned',
                  style: TextStyle(
                    color: isBuying
                        ? canBuy
                            ? Colors.amberAccent
                            : Colors.redAccent
                        : canFire
                            ? Colors.lightGreenAccent
                            : Colors.white38,
                    fontWeight: FontWeight.w900,
                    fontSize: 8.3 * scale,
                  ),
                ),

                // This is the new owned amount while buying.
                if (isBuying)
                  Text(
                    'OWNED x$owned',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: owned > 0
                          ? Colors.lightGreenAccent
                          : Colors.white38,
                      fontWeight: FontWeight.w900,
                      fontSize: 6.7 * scale,
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Color _cardColor({
    required bool isBuying,
    required bool selected,
    required bool canBuy,
    required bool canFire,
  }) {
    if (isBuying) {
      if (selected) return Colors.cyanAccent.withOpacity(0.24);
      return Colors.black.withOpacity(0.34);
    }

    if (canFire) {
      return Colors.redAccent.withOpacity(0.35);
    }

    return Colors.black.withOpacity(0.36);
  }

  Color _borderColor({
    required bool isBuying,
    required bool selected,
    required bool canBuy,
    required bool canFire,
  }) {
    if (isBuying) {
      if (selected) return Colors.cyanAccent;
      if (canBuy) return Colors.white.withOpacity(0.22);
      return Colors.redAccent.withOpacity(0.35);
    }

    if (canFire) return Colors.redAccent.withOpacity(0.75);

    return Colors.white.withOpacity(0.14);
  }
}