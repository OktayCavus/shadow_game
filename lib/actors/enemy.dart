import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shadowbladerush/actors/ninja.dart';
import 'package:shadowbladerush/game.dart';
import 'dart:math' as math;

// Abstract Enemy class with common properties and methods
abstract class Enemy extends CircleComponent
    with HasGameReference<ShadowBladeRush> {
  Enemy({
    required Vector2 startPosition,
    required Color color,
    required this.maxHealth,
  }) : super(
          anchor: Anchor.center,
          paint: Paint()..color = color.withOpacity(0.8),
        ) {
    position = startPosition.clone();
    health = maxHealth;
  }

  double speed = 150.0;
  late double health;
  final double maxHealth;

  // Saldırı cooldown sistemi
  double attackCooldown = 0.0;
  final double attackCooldownDuration = 2.0;
  final double attackDamage = 10.0;

  // Rastgele hareket için değişkenler
  Vector2 _randomDirection = Vector2(1, 0);
  double _randomDirectionTimer = 0.0;
  double get randomDirectionDuration => 2.0; // Alt sınıflar override edebilir
  double get randomMovementSpeed => 100.0; // Alt sınıflar override edebilir

  // Alt sınıflar tarafından override edilecek
  double get attackRange;

  // Ninja'ya doğru hareket için
  Vector2 get directionToNinja {
    final ninjaPosition = game.ninja.position;
    final direction = ninjaPosition - position;
    return direction.normalized();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    radius = 25;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Saldırı cooldown'unu güncelle
    if (attackCooldown > 0) {
      attackCooldown -= dt;
    }

    // Alt sınıf özel update davranışı
    updateBehavior(dt);

    // Ekran sınırları için wrap-around
    _handleScreenBounds();
  }

  // Alt sınıflar tarafından override edilecek davranış
  void updateBehavior(double dt);

  // Alt sınıflar tarafından override edilecek saldırı metodu
  void performAttack();

  void _handleScreenBounds() {
    final screenSize = game.size;

    if (position.x < -radius) {
      position.x = screenSize.x + radius;
    } else if (position.x > screenSize.x + radius) {
      position.x = -radius;
    }

    if (position.y < -radius) {
      position.y = screenSize.y + radius;
    } else if (position.y > screenSize.y + radius) {
      position.y = -radius;
    }
  }

  void takeDamage(double damage) {
    health -= damage;
    if (health <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Health bar çizme
    const healthBarWidth = 40.0;
    const healthBarHeight = 4.0;
    final healthPercentage = health / maxHealth;

    final healthBarRect = Rect.fromLTWH(
      -healthBarWidth / 2,
      -radius - 10,
      healthBarWidth,
      healthBarHeight,
    );

    // Health bar background
    canvas.drawRect(
      healthBarRect,
      Paint()..color = Colors.red.withOpacity(0.3),
    );

    // Current health
    final currentHealthRect = Rect.fromLTWH(
      -healthBarWidth / 2,
      -radius - 10,
      healthBarWidth * healthPercentage,
      healthBarHeight,
    );

    canvas.drawRect(
      currentHealthRect,
      Paint()..color = Colors.green,
    );

    // Saldırı cooldown göstergesi
    if (attackCooldown > 0) {
      final cooldownPercentage = attackCooldown / attackCooldownDuration;
      final cooldownBarRect = Rect.fromLTWH(
        -healthBarWidth / 2,
        -radius - 16,
        healthBarWidth * cooldownPercentage,
        2.0,
      );

      canvas.drawRect(
        cooldownBarRect,
        Paint()..color = Colors.yellow.withOpacity(0.7),
      );
    }
  }

  // Rastgele hareket metodu - alt sınıflar override edebilir
  void updateRandomMovement(double dt) {
    // Rastgele yön değiştirme zamanlaması
    _randomDirectionTimer += dt;
    if (_randomDirectionTimer >= randomDirectionDuration) {
      _randomDirectionTimer = 0.0;

      // Yeni rastgele yön hesapla
      final random = math.Random();
      final angle = random.nextDouble() * 2 * math.pi;
      _randomDirection = Vector2(math.cos(angle), math.sin(angle));
    }

    // Rastgele yönde hareket et
    speed = randomMovementSpeed;
    position.add(_randomDirection * speed * dt);
  }
}
