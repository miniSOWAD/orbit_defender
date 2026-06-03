import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../constants.dart';
import '../orbit_guard_game.dart';

class ShipComponent extends SpriteComponent
    with HasGameRef<OrbitGuardGame>, CollisionCallbacks {
  double orbitAngle = -pi / 2;

  ShipComponent()
      : super(
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('ship.png');
    size = Vector2.all(gameRef.responsiveShipSize);

    add(
      CircleHitbox.relative(
        0.72,
        parentSize: size,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void update(double dt) {
    size = Vector2.all(gameRef.responsiveShipSize);

    if (gameRef.state == GameState.playing ||
        gameRef.state == GameState.buying) {
      if (gameRef.rotatingLeft) {
        orbitAngle -= GameConfig.shipRotationSpeed * dt;
      }

      if (gameRef.rotatingRight) {
        orbitAngle += GameConfig.shipRotationSpeed * dt;
      }
    }

    final center = gameRef.centerPoint;
    final radius = gameRef.responsiveOrbitRadius;

    position = Vector2(
      center.x + cos(orbitAngle) * radius,
      center.y + sin(orbitAngle) * radius,
    );

    angle = orbitAngle + pi / 2;

    super.update(dt);
  }
}