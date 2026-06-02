import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../constants.dart';
import '../orbit_guard_game.dart';

class RocketComponent extends SpriteComponent
    with HasGameRef<OrbitGuardGame>, CollisionCallbacks {
  final RocketConfig config;
  final Vector2 startPosition;
  final Vector2 direction;

  RocketComponent({
    required this.config,
    required this.startPosition,
    required this.direction,
  }) : super(
          size: Vector2.all(GameConfig.rocketSize),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(config.image);
    position = startPosition;

    angle = direction.screenAngle();

    add(
      CircleHitbox.relative(
        0.65,
        parentSize: size,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void update(double dt) {
    if (gameRef.state != GameState.playing) return;

    position += direction * GameConfig.rocketSpeed * dt;

    if (_isOutsideScreen()) {
      removeFromParent();
    }

    super.update(dt);
  }

  bool _isOutsideScreen() {
    const margin = 120.0;

    return position.x < -margin ||
        position.y < -margin ||
        position.x > gameRef.size.x + margin ||
        position.y > gameRef.size.y + margin;
  }
}