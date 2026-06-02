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
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              if (game.isBuyingPhase)
                _BuyingBanner(game: game),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _RotateButton(
                    icon: Icons.rotate_left,
                    onDown: () => game.rotatingLeft = true,
                    onUp: () => game.rotatingLeft = false,
                  ),
                  const SizedBox(width: 18),
                  _RotateButton(
                    icon: Icons.rotate_right,
                    onDown: () => game.rotatingRight = true,
                    onUp: () => game.rotatingRight = false,
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _RocketSelector(game: game),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: game.fireRocket,
                        child: Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: game.isBuyingPhase
                                ? Colors.grey.withOpacity(0.55)
                                : Colors.redAccent.withOpacity(0.88),
                            boxShadow: [
                              if (!game.isBuyingPhase)
                                BoxShadow(
                                  color: Colors.redAccent.withOpacity(0.4),
                                  blurRadius: 24,
                                  spreadRadius: 4,
                                ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.35),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              game.isBuyingPhase ? 'BUY' : 'FIRE',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuyingBanner extends StatefulWidget {
  final OrbitGuardGame game;

  const _BuyingBanner({
    required this.game,
  });

  @override
  State<_BuyingBanner> createState() => _BuyingBannerState();
}

class _BuyingBannerState extends State<_BuyingBanner> {
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 82),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.cyanAccent.withOpacity(0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.game.isFirstBuyingPhase
                ? 'Prepare Your Rockets'
                : 'Reward Claimed! Buy More Rockets',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Buying time left: ${widget.game.buyingTimeLeft.ceil()}s',
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap rocket cards below to buy. Select rocket type before firing.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
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
            color: Colors.white.withOpacity(0.25),
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

class _RocketSelector extends StatefulWidget {
  final OrbitGuardGame game;

  const _RocketSelector({
    required this.game,
  });

  @override
  State<_RocketSelector> createState() => _RocketSelectorState();
}

class _RocketSelectorState extends State<_RocketSelector> {
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
    return Row(
      children: List.generate(GameData.rockets.length, (index) {
        final rocket = GameData.rockets[index];
        final selected = widget.game.selectedRocketIndex == index;
        final owned = widget.game.rocketInventory[index];
        final canBuy = widget.game.gold >= rocket.cost;

        return GestureDetector(
          onTap: () {
            setState(() {
              if (widget.game.isBuyingPhase) {
                widget.game.buyRocket(index);
              } else {
                widget.game.selectRocket(index);
              }
            });
          },
          onLongPress: () {
            setState(() {
              widget.game.selectRocket(index);
            });
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
                    fontWeight: FontWeight.w700,
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