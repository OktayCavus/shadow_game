import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shadowbladerush/game.dart';
import 'package:shadowbladerush/actors/enemy.dart';

class Sword extends SpriteAnimationComponent
    with HasGameReference<ShadowBladeRush> {
  final Vector2 direction;
  final double speed = 400.0;
  final double rotationSpeed = 25.0;
  final double damage = 50.0;
  late final Timer _swordLifeTimer;

  Sword({required this.direction, required Vector2 startPosition})
      : super(
          size: Vector2(66.2, 53),
          anchor: Anchor.center,
          // paint: Paint()..color = Colors.grey.shade300,
        ) {
    position = startPosition.clone();
    angle = atan2(direction.y, direction.x);

    _swordLifeTimer = Timer(1.0, onTick: () => removeFromParent());
  }

  @override
  FutureOr<void> onLoad() async {
    // sprite = await game.loadSprite('fire2.png');
    animation = await game.loadSpriteAnimation(
        'firee.png',
        SpriteAnimationData.sequenced(
          amount: 5,
          textureSize: Vector2(66.2, 53),
          stepTime: 0.1,
        ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.add(direction * speed * dt);

    // angle += rotationSpeed * dt;

    _swordLifeTimer.update(dt);

    // Düşmanlarla çarpışma kontrolü
    _checkEnemyCollisions();

    if (position.x > game.size.x + 50 ||
        position.x < -50 ||
        position.y > game.size.y + 50 ||
        position.y < -50) {
      removeFromParent();
    }
  }

  void _checkEnemyCollisions() {
    final enemies = game.children.whereType<Enemy>().toList();

    for (final enemy in enemies) {
      final distance = position.distanceTo(enemy.position);
      if (distance < (size.x / 2 + enemy.radius)) {
        // Çarpışma gerçekleşti
        enemy.takeDamage(damage);
        removeFromParent();
        break;
      }
    }
  }
}
