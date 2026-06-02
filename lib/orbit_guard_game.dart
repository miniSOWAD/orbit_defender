import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/earth.dart';
import 'components/meteor.dart';
import 'components/rocket.dart';
import 'components/ship.dart';
import 'components/star_background.dart';
import 'constants.dart';

class OrbitGuardGame extends FlameGame
    with HasCollisionDetection, TapDetector {
  late EarthComponent earth;
  late ShipComponent ship;

  GameState state = GameState.mainMenu;

  double earthHp = GameConfig.earthMaxHp;
  double shipHp = GameConfig.shipMaxHp;

  int gold = 0;
  int score = 0;

  int selectedRocketIndex = 0;

  final List<int> rocketInventory = [0, 0, 0, 0];

  bool rotatingLeft = false;
  bool rotatingRight = false;

  bool isFirstBuyingPhase = true;

  double buyingTimer = 0;
  double currentBuyingDuration = GameConfig.firstBuyingDuration;

  final Random _random = Random();

  final List<double> _meteorTimers = [0, 0, 0, 0];

  double _survivalRewardTimer = 0;
  double survivedSeconds = 0;

  Vector2 get centerPoint => size / 2;

  bool get isBuyingPhase => state == GameState.buying;

  double get buyingTimeLeft {
    final timeLeft = currentBuyingDuration - buyingTimer;
    return timeLeft < 0 ? 0 : timeLeft;
  }

  @override
  Color backgroundColor() {
    return GameConfig.spaceBackgroundColor;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(StarBackground());

    earth = EarthComponent();
    ship = ShipComponent();

    add(earth);
    add(ship);

    pauseEngine();
  }

  @override
  void update(double dt) {
    if (state == GameState.buying) {
      super.update(dt);
      _updateBuyingPhase(dt);
      return;
    }

    if (state != GameState.playing) return;

    super.update(dt);

    survivedSeconds += dt;

    _updateRewardTimer(dt);
    _updateMeteorSpawning(dt);
    _checkGameOver();
  }

  void startNewGame() {
    children.whereType<MeteorComponent>().forEach((m) => m.removeFromParent());
    children.whereType<RocketComponent>().forEach((r) => r.removeFromParent());

    earthHp = GameConfig.earthMaxHp;
    shipHp = GameConfig.shipMaxHp;

    gold = GameConfig.startingGold;
    score = 0;

    selectedRocketIndex = 0;

    for (int i = 0; i < rocketInventory.length; i++) {
      rocketInventory[i] = 0;
    }

    for (int i = 0; i < _meteorTimers.length; i++) {
      _meteorTimers[i] = 0;
    }

    _survivalRewardTimer = 0;
    survivedSeconds = 0;

    isFirstBuyingPhase = true;

    _startBuyingPhase(GameConfig.firstBuyingDuration);

    overlays.remove('MainMenu');
    overlays.remove('PauseMenu');
    overlays.remove('GameOverMenu');

    overlays.add('GameHud');
    overlays.add('Controls');

    resumeEngine();
  }

  void _startBuyingPhase(double duration) {
    state = GameState.buying;
    buyingTimer = 0;
    currentBuyingDuration = duration;

    rotatingLeft = false;
    rotatingRight = false;
  }

  void _updateBuyingPhase(double dt) {
    buyingTimer += dt;

    if (buyingTimer >= currentBuyingDuration) {
      _endBuyingPhase();
    }
  }

  void _endBuyingPhase() {
    state = GameState.playing;
    isFirstBuyingPhase = false;

    buyingTimer = 0;
  }

  void _startRewardBuyingPhase() {
    gold += GameConfig.survivalRewardGold;
    _startBuyingPhase(GameConfig.repeatBuyingDuration);
  }

  void _updateRewardTimer(double dt) {
    _survivalRewardTimer += dt;

    if (_survivalRewardTimer >= GameConfig.survivalRewardInterval) {
      _survivalRewardTimer = 0;
      _startRewardBuyingPhase();
    }
  }

  void _updateMeteorSpawning(double dt) {
    for (int i = 0; i < GameData.meteors.length; i++) {
      _meteorTimers[i] += dt;

      final config = GameData.meteors[i];

      if (_meteorTimers[i] >= config.spawnInterval) {
        _meteorTimers[i] = 0;
        spawnMeteor(config);
      }
    }
  }

  void spawnMeteor(MeteorConfig config) {
    final spawnPosition = _getRandomOuterSpawnPosition();

    add(
      MeteorComponent(
        config: config,
        startPosition: spawnPosition,
      ),
    );
  }

  Vector2 _getRandomOuterSpawnPosition() {
    final margin = 100.0;
    final side = _random.nextInt(4);

    switch (side) {
      case 0:
        return Vector2(_random.nextDouble() * size.x, -margin);
      case 1:
        return Vector2(size.x + margin, _random.nextDouble() * size.y);
      case 2:
        return Vector2(_random.nextDouble() * size.x, size.y + margin);
      default:
        return Vector2(-margin, _random.nextDouble() * size.y);
    }
  }

  void selectRocket(int index) {
    selectedRocketIndex = index;
  }

  bool buyRocket(int index) {
    if (!isBuyingPhase) return false;

    final rocketConfig = GameData.rockets[index];

    if (gold < rocketConfig.cost) return false;

    gold -= rocketConfig.cost;
    rocketInventory[index]++;

    selectedRocketIndex = index;

    return true;
  }

  void fireRocket() {
    if (state != GameState.playing) return;

    final rocketConfig = GameData.rockets[selectedRocketIndex];

    if (rocketInventory[selectedRocketIndex] <= 0) return;

    rocketInventory[selectedRocketIndex]--;

    final target = findClosestMeteor();

    Vector2 direction;

    if (target != null) {
      direction = (target.position - ship.position).normalized();
    } else {
      direction = (ship.position - centerPoint).normalized();
    }

    add(
      RocketComponent(
        config: rocketConfig,
        startPosition: ship.position.clone(),
        direction: direction,
      ),
    );
  }

  MeteorComponent? findClosestMeteor() {
    final meteors = children.whereType<MeteorComponent>().toList();

    if (meteors.isEmpty) return null;

    meteors.sort((a, b) {
      final da = a.position.distanceTo(ship.position);
      final db = b.position.distanceTo(ship.position);
      return da.compareTo(db);
    });

    return meteors.first;
  }

  void pauseGame() {
    if (state != GameState.playing && state != GameState.buying) return;

    state = GameState.paused;
    pauseEngine();

    rotatingLeft = false;
    rotatingRight = false;

    overlays.remove('Controls');
    overlays.add('PauseMenu');
  }

  void resumeGame() {
    if (state != GameState.paused) return;

    state = GameState.playing;
    resumeEngine();

    overlays.remove('PauseMenu');
    overlays.add('Controls');
  }

  void goToMainMenu() {
    state = GameState.mainMenu;
    pauseEngine();

    rotatingLeft = false;
    rotatingRight = false;

    overlays.remove('GameHud');
    overlays.remove('Controls');
    overlays.remove('PauseMenu');
    overlays.remove('GameOverMenu');
    overlays.add('MainMenu');
  }

  void _gameOver() {
    state = GameState.gameOver;
    pauseEngine();

    rotatingLeft = false;
    rotatingRight = false;

    overlays.remove('Controls');
    overlays.add('GameOverMenu');
  }

  void _checkGameOver() {
    if (earthHp <= 0 || shipHp <= 0) {
      _gameOver();
    }
  }

  void damageEarth(double damage) {
    earthHp -= damage;
    if (earthHp < 0) earthHp = 0;
  }

  void damageShip(double damage) {
    shipHp -= damage;
    if (shipHp < 0) shipHp = 0;
  }

  void addScore(int amount) {
    score += amount;
  }
}