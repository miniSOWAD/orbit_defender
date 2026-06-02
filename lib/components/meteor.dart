import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../constants.dart';
import '../orbit_guard_game.dart';
import 'earth.dart';
import 'rocket.dart';

class MeteorComponent extends SpriteComponent
    with HasGameRef<OrbitGuardGame>, CollisionCallbacks {
  final MeteorConfig config;
  final Vector2 startPosition;

  late double hp;

  MeteorComponent({
    required this.config,
    required this.startPosition,
  }) : super(
          size: Vector2.all(GameConfig.meteorSize),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(config.image);
    position = startPosition;
    hp = config.hp;

    add(
      CircleHitbox.relative(
        0.82,
        parentSize: size,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void update(double dt) {
    if (gameRef.state != GameState.playing) return;

    final direction = (gameRef.centerPoint - position).normalized();
    position += direction * config.speed * dt;

    angle += 1.3 * dt;

    super.update(dt);
  }

  void takeDamage(double damage) {
    hp -= damage;

    if (hp <= 0) {
      gameRef.addScore(config.hp.toInt());
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is EarthComponent) {
      gameRef.damageEarth(config.earthDamage);
      removeFromParent();
    }

    if (other is RocketComponent) {
      takeDamage(other.config.damage);
      other.removeFromParent();
    }
  }
}