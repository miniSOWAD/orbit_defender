import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../constants.dart';
import '../orbit_guard_game.dart';
import 'meteor.dart';

class ShipComponent extends SpriteComponent
    with HasGameRef<OrbitGuardGame>, CollisionCallbacks {
  double orbitAngle = -pi / 2;

  ShipComponent()
      : super(
          size: Vector2.all(GameConfig.shipSize),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('ship.png');

    add(
      CircleHitbox.relative(
        0.8,
        parentSize: size,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void update(double dt) {
    if (gameRef.state == GameState.playing || gameRef.state == GameState.buying) {
      if (gameRef.rotatingLeft) {
        orbitAngle -= GameConfig.shipRotationSpeed * dt;
      }

      if (gameRef.rotatingRight) {
        orbitAngle += GameConfig.shipRotationSpeed * dt;
      }
    }

    final center = gameRef.centerPoint;

    position = Vector2(
      center.x + cos(orbitAngle) * GameConfig.shipOrbitRadius,
      center.y + sin(orbitAngle) * GameConfig.shipOrbitRadius,
    );

    angle = orbitAngle + pi / 2;

    super.update(dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is MeteorComponent) {
      gameRef.damageShip(other.config.earthDamage);
      other.removeFromParent();
    }
  }
}