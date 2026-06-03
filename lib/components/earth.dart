import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../constants.dart';
import '../orbit_guard_game.dart';

class EarthComponent extends SpriteComponent
    with HasGameRef<OrbitGuardGame>, CollisionCallbacks {
  String _currentImage = '';

  EarthComponent()
      : super(
          size: Vector2.all(GameConfig.earthSize),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    position = gameRef.centerPoint;
    await updateEarthSprite(force: true);

    add(
      CircleHitbox.relative(
        0.86,
        parentSize: size,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void update(double dt) {
    position = gameRef.centerPoint;
    updateEarthSprite();
    super.update(dt);
  }

  Future<void> updateEarthSprite({bool force = false}) async {
    final hp = gameRef.earthHp;
    String image;

    if (hp <= 0) {
      image = 'earth0.png';
    } else if (hp <= 25) {
      image = 'earth25.png';
    } else if (hp <= 50) {
      image = 'earth50.png';
    } else if (hp <= 100) {
      image = 'earth100.png';
    } else if (hp <= 150) {
      image = 'earth150.png';
    } else {
      image = 'earth200.png';
    }

    if (!force && image == _currentImage) return;

    _currentImage = image;
    sprite = await gameRef.loadSprite(image);
  }
}