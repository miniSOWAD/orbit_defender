import 'dart:ui';

enum GameState {
  splash,
  mainMenu,
  buying,
  playing,
  paused,
  earthDestroyed,
  gameOver,
}

class GameConfig {
  static const double earthMaxHp = 200;
  static const double shipMaxHp = 100;

  static const int startingGold = 300;

  static const int shipHealCost = 20;
  static const double shipHealAmount = 10;

  static const double shipRotationSpeed = 2.7;
  static const double rocketSpeed = 620;

  static const double firstBuyingDuration = 10;
  static const double repeatBuyingDuration = 5;

  static const double survivalRewardInterval = 30;
  static const int survivalRewardGold = 300;

  static const double earthDeathDelay = 2;

  static const Color spaceBackgroundColor = Color(0xFF050712);
}

class MeteorConfig {
  final String image;
  final double hp;
  final double earthDamage;
  final double spawnInterval;
  final double speed;
  final int typeIndex;

  const MeteorConfig({
    required this.image,
    required this.hp,
    required this.earthDamage,
    required this.spawnInterval,
    required this.speed,
    required this.typeIndex,
  });
}

class RocketConfig {
  final String image;
  final double damage;
  final int cost;
  final int typeIndex;

  const RocketConfig({
    required this.image,
    required this.damage,
    required this.cost,
    required this.typeIndex,
  });
}

class GameData {
  static const List<MeteorConfig> meteors = [
    MeteorConfig(
      image: 'met1.png',
      hp: 10,
      earthDamage: 5,
      spawnInterval: 3,
      speed: 85,
      typeIndex: 0,
    ),
    MeteorConfig(
      image: 'met2.png',
      hp: 25,
      earthDamage: 12,
      spawnInterval: 5,
      speed: 72,
      typeIndex: 1,
    ),
    MeteorConfig(
      image: 'met3.png',
      hp: 60,
      earthDamage: 28,
      spawnInterval: 10,
      speed: 58,
      typeIndex: 2,
    ),
    MeteorConfig(
      image: 'met4.png',
      hp: 150,
      earthDamage: 70,
      spawnInterval: 25,
      speed: 42,
      typeIndex: 3,
    ),
  ];

  static const List<RocketConfig> rockets = [
    RocketConfig(
      image: 'rok1.png',
      damage: 5,
      cost: 4,
      typeIndex: 0,
    ),
    RocketConfig(
      image: 'rok2.png',
      damage: 15,
      cost: 13,
      typeIndex: 1,
    ),
    RocketConfig(
      image: 'rok3.png',
      damage: 30,
      cost: 28,
      typeIndex: 2,
    ),
    RocketConfig(
      image: 'rok4.png',
      damage: 60,
      cost: 60,
      typeIndex: 3,
    ),
  ];
}