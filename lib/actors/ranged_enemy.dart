import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shadowbladerush/actors/enemy.dart';
import 'package:shadowbladerush/actors/ninja.dart';
import 'package:shadowbladerush/game.dart';

class RangedEnemy extends Enemy {
  RangedEnemy({required super.startPosition})
      : super(
          color: Colors.blue,
          maxHealth: 80.0,
        );

  @override
  double get attackRange => 200.0;

  final double preferredDistance =
      150.0; // Ninja'dan bu mesafede durmaya çalışır

  @override
  double get randomDirectionDuration => 1.5; // 1.5 saniyede bir yön değiştir

  @override
  double get randomMovementSpeed => 120.0; // Normal hızda hareket

  @override
  void updateBehavior(double dt) {
    final distanceToNinja = position.distanceTo(game.ninja.position);

    // Ninja kamuflajdaysa rastgele hareket et
    if (game.ninja.isInCamouflage) {
      updateRandomMovement(dt);
      return;
    }

    // Normal davranış - mesafe kontrolü ile hareket
    final direction = directionToNinja;

    if (distanceToNinja < preferredDistance - 20) {
      // Çok yakın - geri çekil
      position.add(-direction * speed * dt);
    } else if (distanceToNinja > preferredDistance + 20) {
      // Çok uzak - yaklaş
      position.add(direction * speed * dt);
    }
    // İdeal mesafede ise hareket etme

    // Saldırı menzilinde ise ateş et
    if (distanceToNinja <= attackRange &&
        attackCooldown <= 0 &&
        game.children.whereType<Ninja>().isNotEmpty) {
      performAttack();
      attackCooldown = attackCooldownDuration;
    }
  }

  @override
  void performAttack() {
    // Projectile oluştur (basit bir çember olarak)
    final projectile = Projectile(
      startPosition: position.clone(),
      targetPosition: game.ninja.position.clone(),
      damage: attackDamage,
    );
    game.add(projectile);

    // Saldırı efekti - renk değiştir
    final originalColor = paint.color;
    paint.color = Colors.purple.withOpacity(0.9);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (isMounted) {
        paint.color = originalColor;
      }
    });
  }
}

// Projektil sınıfı - artık public
class Projectile extends SpriteAnimationComponent
    with HasGameReference<ShadowBladeRush> {
  Projectile({
    required Vector2 startPosition,
    required Vector2 targetPosition,
    required this.damage,
  }) : super(
          anchor: Anchor.center,
          // paint: Paint()..color = Colors.yellow,
          size: Vector2(26, 30),
        ) {
    position = startPosition.clone();
    _direction = (targetPosition - startPosition).normalized();
  }

  final double damage;
  late final Vector2 _direction;
  final double speed = 300.0;
  double lifetime = 3.0; // 3 saniye sonra kaybolur

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // radius = 8;
    animation = await game.loadSpriteAnimation(
        'enemy_fire.png',
        SpriteAnimationData.sequenced(
          amount: 8,
          textureSize: Vector2(26, 30),
          stepTime: 0.1,
        ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Hareket et
    position.add(_direction * speed * dt);

    // Yaşam süresini azalt
    lifetime -= dt;
    if (lifetime <= 0) {
      removeFromParent();
      return;
    }

    // Ninja'ya çarpma kontrolü
    final distanceToNinja = position.distanceTo(game.ninja.position);
    if (distanceToNinja < size.x) {
      // 20 ninja'nın yarıçapı
      // Ninja kamuflajda değilse hasar ver
      if (!game.ninja.isInCamouflage) {
        game.ninja.takeDamage(damage);
      }
      removeFromParent();
    }

    // Ekran sınırları kontrolü
    final screenSize = game.size;
    if (position.x < 0 ||
        position.x > screenSize.x ||
        position.y < 0 ||
        position.y > screenSize.y) {
      removeFromParent();
    }
  }
}
