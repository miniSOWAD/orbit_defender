import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../constants.dart';
import '../orbit_guard_game.dart';
import 'meteor.dart';

class RocketComponent extends SpriteComponent
    with HasGameRef<OrbitGuardGame>, CollisionCallbacks {
  final RocketConfig config;
  final Vector2 startPosition;
  MeteorComponent? target;

  bool hasHit = false;

  RocketComponent({
    required this.config,
    required this.startPosition,
    required this.target,
  }) : super(
          size: Vector2.all(GameConfig.rocketSize),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(config.image);
    position = startPosition;

    add(
      CircleHitbox.relative(
        0.75,
        parentSize: size,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void update(double dt) {
    if (gameRef.state != GameState.playing) return;
    if (hasHit) return;

    final currentTarget = target;

    if (currentTarget == null ||
        currentTarget.isRemoved ||
        currentTarget.isDead) {
      removeFromParent();
      return;
    }

    final toTarget = currentTarget.position - position;
    final distanceThisFrame = GameConfig.rocketSpeed * dt;

    if (toTarget.length <= distanceThisFrame + GameConfig.meteorSize * 0.25) {
      _hitTarget(currentTarget);
      return;
    }

    final direction = toTarget.normalized();

    position += direction * distanceThisFrame;
    angle = direction.screenAngle();

    super.update(dt);
  }

  void _hitTarget(MeteorComponent meteor) {
    if (hasHit) return;

    hasHit = true;

    meteor.takeDamage(config.damage);
    removeFromParent();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (hasHit) return;

    if (other is MeteorComponent) {
      _hitTarget(other);
    }
  }
}