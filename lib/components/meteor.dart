import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../constants.dart';
import '../orbit_guard_game.dart';

class MeteorComponent extends SpriteComponent
    with HasGameRef<OrbitGuardGame>, CollisionCallbacks {
  final MeteorConfig config;
  final Vector2 startPosition;

  late double hp;

  bool hasHitSomething = false;
  bool isDead = false;

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
        0.78,
        parentSize: size,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void update(double dt) {
    if (gameRef.state != GameState.playing) return;
    if (isDead || hasHitSomething) return;

    _checkSurfaceHitWithEarth();
    _checkHitWithShip();

    if (isDead || hasHitSomething) return;

    final direction = (gameRef.centerPoint - position).normalized();
    position += direction * config.speed * dt;

    angle += 1.3 * dt;

    super.update(dt);
  }

  void _checkSurfaceHitWithEarth() {
    final earthRadius = GameConfig.earthSize * 0.44;
    final meteorRadius = GameConfig.meteorSize * 0.34;

    final surfaceDistance = earthRadius + meteorRadius;
    final currentDistance = position.distanceTo(gameRef.centerPoint);

    if (currentDistance <= surfaceDistance) {
      hasHitSomething = true;
      gameRef.damageEarth(config.earthDamage);
      removeFromParent();
    }
  }

  void _checkHitWithShip() {
    final shipRadius = GameConfig.shipSize * 0.38;
    final meteorRadius = GameConfig.meteorSize * 0.34;

    final hitDistance = shipRadius + meteorRadius;
    final currentDistance = position.distanceTo(gameRef.ship.position);

    if (currentDistance <= hitDistance) {
      hasHitSomething = true;
      gameRef.damageShip(config.earthDamage);
      removeFromParent();
    }
  }

  void takeDamage(double damage) {
    if (isDead || hasHitSomething) return;

    hp -= damage;

    if (hp <= 0) {
      destroyMeteor();
    }
  }

  void destroyMeteor() {
    if (isDead) return;

    isDead = true;
    gameRef.addScore(config.hp.toInt());
    removeFromParent();
  }
}