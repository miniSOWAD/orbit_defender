import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/earth.dart';
import 'components/meteor.dart';
import 'components/rocket.dart';
import 'components/ship.dart';
import 'components/star_background.dart';
import 'constants.dart';

class OrbitGuardGame extends FlameGame with HasCollisionDetection {
  late EarthComponent earth;
  late ShipComponent ship;

  GameState state = GameState.splash;
  GameState _stateBeforePause = GameState.playing;

  double earthHp = GameConfig.earthMaxHp;
  double shipHp = GameConfig.shipMaxHp;

  int gold = 0;
  int score = 0;
  int lastScore = 0;
  double lastSurvivedSeconds = 0;

  int selectedRocketIndex = 0;
  final List<int> rocketInventory = [0, 0, 0, 0];

  bool rotatingLeft = false;
  bool rotatingRight = false;

  bool hasActiveRun = false;
  bool isFirstBuyingPhase = true;

  double buyingTimer = 0;
  double currentBuyingDuration = GameConfig.firstBuyingDuration;

  double _survivalRewardTimer = 0;
  double survivedSeconds = 0;

  double _earthDeathTimer = 0;

  final List<double> _meteorTimers = [0, 0, 0, 0];
  final Random _random = Random();

  Vector2 get centerPoint => size / 2;

  bool get isBuyingPhase => state == GameState.buying;

  double get buyingTimeLeft {
    final left = currentBuyingDuration - buyingTimer;
    return left < 0 ? 0 : left;
  }

  double get nextRewardTimeLeft {
    final left = GameConfig.survivalRewardInterval - _survivalRewardTimer;
    return left < 0 ? 0 : left;
  }

  bool get earthDyingWarning => earthHp > 0 && earthHp <= 25;

  @override
  Color backgroundColor() => GameConfig.spaceBackgroundColor;

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
    if (state == GameState.splash ||
        state == GameState.mainMenu ||
        state == GameState.paused ||
        state == GameState.gameOver) {
      super.update(dt);
      return;
    }

    if (state == GameState.earthDestroyed) {
      super.update(dt);

      _earthDeathTimer += dt;

      if (_earthDeathTimer >= GameConfig.earthDeathDelay) {
        _showGameOver();
      }

      return;
    }

    if (state == GameState.buying) {
      super.update(dt);
      _updateBuyingPhase(dt);
      return;
    }

    if (state == GameState.playing) {
      super.update(dt);

      survivedSeconds += dt;

      _updateRewardTimer(dt);
      _updateMeteorSpawning(dt);
      _checkDeath();
    }
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

    rotatingLeft = false;
    rotatingRight = false;

    _survivalRewardTimer = 0;
    survivedSeconds = 0;
    _earthDeathTimer = 0;

    hasActiveRun = true;
    isFirstBuyingPhase = true;

    overlays.remove('MainMenu');
    overlays.remove('PauseMenu');
    overlays.remove('GameOverMenu');

    overlays.add('GameHud');
    overlays.add('Controls');

    _startBuyingPhase(GameConfig.firstBuyingDuration);

    resumeEngine();
  }

  void resumeExistingRun() {
    if (!hasActiveRun) return;

    overlays.remove('MainMenu');
    overlays.add('GameHud');
    overlays.add('Controls');

    state = _stateBeforePause;
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

  void _updateRewardTimer(double dt) {
    _survivalRewardTimer += dt;

    if (_survivalRewardTimer >= GameConfig.survivalRewardInterval) {
      _survivalRewardTimer = 0;
      gold += GameConfig.survivalRewardGold;
      _startBuyingPhase(GameConfig.repeatBuyingDuration);
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
    add(
      MeteorComponent(
        config: config,
        startPosition: _getRandomOuterSpawnPosition(),
      ),
    );
  }

  Vector2 _getRandomOuterSpawnPosition() {
    const margin = 100.0;
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

    final config = GameData.rockets[index];

    if (gold < config.cost) return false;

    gold -= config.cost;
    rocketInventory[index]++;
    selectedRocketIndex = index;

    return true;
  }

  bool buyShipHp() {
    if (!isBuyingPhase) return false;
    if (shipHp >= GameConfig.shipMaxHp) return false;
    if (gold < GameConfig.shipHealCost) return false;

    gold -= GameConfig.shipHealCost;
    shipHp += GameConfig.shipHealAmount;

    if (shipHp > GameConfig.shipMaxHp) {
      shipHp = GameConfig.shipMaxHp;
    }

    return true;
  }

  void fireRocket() {
  if (state != GameState.playing) return;

  if (rocketInventory[selectedRocketIndex] <= 0) return;

  final target = findClosestMeteorInFront();

  if (target == null) {
    return;
  }

  final rocketConfig = GameData.rockets[selectedRocketIndex];

  rocketInventory[selectedRocketIndex]--;

  add(
    RocketComponent(
      config: rocketConfig,
      startPosition: ship.position.clone(),
      target: target,
    ),
  );
}

  MeteorComponent? findClosestMeteorInFront() {
    final meteors = children.whereType<MeteorComponent>().toList();

    if (meteors.isEmpty) return null;

    final shipForward = (ship.position - centerPoint).normalized();

    final visibleMeteors = meteors.where((meteor) {
      final toMeteor = (meteor.position - ship.position).normalized();

      final dot = shipForward.dot(toMeteor);

      return dot >= 0;
    }).toList();

    if (visibleMeteors.isEmpty) return null;

    visibleMeteors.sort((a, b) {
      final da = a.position.distanceTo(ship.position);
      final db = b.position.distanceTo(ship.position);
      return da.compareTo(db);
    });

    return visibleMeteors.first;
  }

  void pauseGame() {
    if (state != GameState.playing && state != GameState.buying) return;

    _stateBeforePause = state;
    state = GameState.paused;

    rotatingLeft = false;
    rotatingRight = false;

    pauseEngine();

    overlays.remove('Controls');
    overlays.add('PauseMenu');
  }

  void resumeGame() {
    if (state != GameState.paused) return;

    state = _stateBeforePause;

    resumeEngine();

    overlays.remove('PauseMenu');
    overlays.add('Controls');
  }

  void goToMainMenu() {
    if (state != GameState.gameOver) {
      _stateBeforePause = state;
    }

    state = GameState.mainMenu;

    rotatingLeft = false;
    rotatingRight = false;

    pauseEngine();

    overlays.remove('GameHud');
    overlays.remove('Controls');
    overlays.remove('PauseMenu');
    overlays.remove('GameOverMenu');
    overlays.add('MainMenu');
  }

  void damageEarth(double damage) {
    if (state == GameState.earthDestroyed || state == GameState.gameOver) {
      return;
    }

    earthHp -= damage;

    if (earthHp <= 0) {
      earthHp = 0;
      _startEarthDestroyedSequence();
    }
  }

  void damageShip(double damage) {
    if (state == GameState.earthDestroyed || state == GameState.gameOver) {
      return;
    }

    shipHp -= damage;

    if (shipHp <= 0) {
      shipHp = 0;
      _showGameOver();
    }
  }

  void _checkDeath() {
    if (earthHp <= 0) {
      _startEarthDestroyedSequence();
    } else if (shipHp <= 0) {
      _showGameOver();
    }
  }

  void _startEarthDestroyedSequence() {
    state = GameState.earthDestroyed;
    _earthDeathTimer = 0;

    rotatingLeft = false;
    rotatingRight = false;

    children.whereType<MeteorComponent>().forEach((m) => m.removeFromParent());
    children.whereType<RocketComponent>().forEach((r) => r.removeFromParent());

    overlays.remove('Controls');
  }

  void _showGameOver() {
    lastScore = score;
    lastSurvivedSeconds = survivedSeconds;

    state = GameState.gameOver;
    hasActiveRun = false;

    rotatingLeft = false;
    rotatingRight = false;

    pauseEngine();

    overlays.remove('Controls');
    overlays.add('GameOverMenu');
  }

  void finishGameOverAndReturnToMenu() {
    goToMainMenu();
  }

  void addScore(int amount) {
    score += amount;
  }
}