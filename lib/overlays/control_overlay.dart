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
                            color: Colors.redAccent.withOpacity(0.88),
                            boxShadow: [
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
                          child: const Center(
                            child: Text(
                              'FIRE',
                              style: TextStyle(
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
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(GameData.rockets.length, (index) {
        final rocket = GameData.rockets[index];
        final selected = widget.game.selectedRocketIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              widget.game.selectRocket(index);
            });
          },
          child: Container(
            margin: const EdgeInsets.only(left: 7),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.cyanAccent.withOpacity(0.28)
                  : Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(12),
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
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${rocket.cost}G',
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 11,
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