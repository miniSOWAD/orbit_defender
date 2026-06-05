import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../orbit_guard_game.dart';

class MainMenu extends StatelessWidget {
  final OrbitGuardGame game;

  const MainMenu({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Image.asset(
            'assets/images/menu.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.42),
          ),
          Center(
            child: Container(
              width: 285,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.52),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.cyanAccent.withOpacity(0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.16),
                    blurRadius: 28,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'ORBIT DEFENDER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Protect Earth. Destroy meteors.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 18),

                  if (game.hasActiveRun) ...[
                    _MenuButton(
                      label: 'RESUME',
                      onTap: game.resumeExistingRun,
                    ),
                    const SizedBox(height: 8),
                  ],

                  _MenuButton(
                    label: 'NEW GAME',
                    onTap: () => _showStartGameDialog(context),
                  ),
                  const SizedBox(height: 8),
                  _MenuButton(
                    label: 'HELP',
                    onTap: () => _showHelp(context),
                  ),
                  const SizedBox(height: 8),
                  _MenuButton(
                    label: 'SCORE BOARD',
                    onTap: () => _showScoreBoard(context, game),
                  ),
                  const SizedBox(height: 8),
                  _MenuButton(
                    label: 'EXIT',
                    onTap: _exitGame,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

void _showStartGameDialog(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final dialogWidth = (screen.width * 0.48).clamp(320.0, 430.0);
    final dialogMaxHeight = screen.height * 0.82;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dialogWidth,
              maxHeight: dialogMaxHeight,
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF090D1A).withOpacity(0.96),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.cyanAccent.withOpacity(0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.18),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'HOW TO PLAY',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        'You get 20 seconds to buy rockets now.\n\n'
                        'After surviving 45 seconds, you will again be rewarded with more gold and get 12 seconds to buy new rockets.\n\n'
                        'There are 4 types of missiles, from cheaper low-damage missiles to expensive high-damage missiles.\n\n'
                        'There are also 4 different sizes of meteors coming toward your planet.\n\n'
                        'Use your economy wisely. Do not waste a powerful costly rocket on a small meteor, and do not rely only on cheap rockets or you may go short on damage, which leads to ultimate death.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: screen.height < 360 ? 9.5 : 10.5,
                          height: 1.28,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      game.startNewGame();
                    },
                    child: Container(
                      width: 145,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF00E5FF),
                            Color(0xFF00FFA3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Text(
                        'OK, PLAY',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 390,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF090D1A).withOpacity(0.97),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.42),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'GAME HELP',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Orbit Defender is a survival defense game. Your planet is under meteor attack. Rotate the ship around Earth and fire missiles toward incoming meteors before they hit the planet or your ship.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11.2,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),

                  _HelpSection(
                    title: 'MISSILES',
                    rows: GameData.rockets.map((rocket) {
                      return 'R${rocket.typeIndex + 1}: ${rocket.damage.toInt()} damage | ${rocket.cost} gold';
                    }).toList(),
                  ),

                  const SizedBox(height: 10),

                  _HelpSection(
                    title: 'METEORS',
                    rows: GameData.meteors.map((meteor) {
                      return 'MET${meteor.typeIndex + 1}: ${meteor.hp.toInt()} HP | ${meteor.earthDamage.toInt()} damage';
                    }).toList(),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Economy Tip: Match missile power with meteor size. Using expensive missiles on weak meteors wastes gold, but buying only weak missiles may leave you unable to destroy stronger meteors.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 10.5,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 130,
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Text(
                        'OK',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showScoreBoard(BuildContext context, OrbitGuardGame game) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF101426),
          title: const Text(
            'SCORE BOARD',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Last Score: ${game.lastScore}\n'
            'Last Survival Time: ${game.lastSurvivedSeconds.toInt()}s',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _exitGame() {
    SystemNavigator.pop();
  }
}

class _HelpSection extends StatelessWidget {
  final String title;
  final List<String> rows;

  const _HelpSection({
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                row,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00E5FF),
              Color(0xFF00FFA3),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.18),
              blurRadius: 12,
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 11.5,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}