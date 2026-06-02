import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../constants.dart';
import '../orbit_guard_game.dart';

class EarthComponent extends SpriteComponent
    with HasGameRef<OrbitGuardGame>, CollisionCallbacks {
  EarthComponent()
      : super(
          size: Vector2.all(GameConfig.earthSize),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('earth100.png');
    position = gameRef.centerPoint;

    add(
      CircleHitbox.relative(
        0.92,
        parentSize: size,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void update(double dt) {
    position = gameRef.centerPoint;
    super.update(dt);
  }
}