import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../orbit_guard_game.dart';

class StarBackground extends PositionComponent with HasGameRef<OrbitGuardGame> {
  final Random _random = Random();
  final List<_Star> _stars = [];

  @override
  Future<void> onLoad() async {
    priority = -100;
    size = gameRef.size;

    for (int i = 0; i < 90; i++) {
      _stars.add(
        _Star(
          position: Vector2(
            _random.nextDouble() * gameRef.size.x,
            _random.nextDouble() * gameRef.size.y,
          ),
          radius: 1 + _random.nextDouble() * 1.8,
          speed: 8 + _random.nextDouble() * 22,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    for (final star in _stars) {
      star.position.y += star.speed * dt;

      if (star.position.y > gameRef.size.y) {
        star.position.y = 0;
        star.position.x = _random.nextDouble() * gameRef.size.x;
      }
    }

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.white.withOpacity(0.75);

    for (final star in _stars) {
      canvas.drawCircle(
        Offset(star.position.x, star.position.y),
        star.radius,
        paint,
      );
    }
  }
}

class _Star {
  final Vector2 position;
  final double radius;
  final double speed;

  _Star({
    required this.position,
    required this.radius,
    required this.speed,
  });
}