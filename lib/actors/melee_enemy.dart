import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shadowbladerush/actors/enemy.dart';
import 'package:shadowbladerush/actors/ninja.dart';

class MeleeEnemy extends Enemy {
  MeleeEnemy({required super.startPosition})
      : super(
          color: Colors.red,
          maxHealth: 100.0,
        );

  @override
  double get attackRange => 60.0;

  @override
  double get randomDirectionDuration => 2.0; // 2 saniyede bir yön değiştir

  @override
  double get randomMovementSpeed => 80.0; // Biraz yavaş hareket

  @override
  void updateBehavior(double dt) {
    final distanceToNinja = position.distanceTo(game.ninja.position);

    // Ninja kamuflajdaysa rastgele hareket et
    if (game.ninja.isInCamouflage) {
      updateRandomMovement(dt);
      return;
    }

    // Normal davranış - ninja'yı takip et
    final direction = directionToNinja;

    if (distanceToNinja < attackRange) {
      // Saldırı menzilinde - saldır ve dur
      if (attackCooldown <= 0 &&
          !game.ninja.isQuickAttacking &&
          game.children.whereType<Ninja>().isNotEmpty) {
        performAttack();
        attackCooldown = attackCooldownDuration;
      }
      speed = 0.0; // Yakınken dur
    } else {
      // Normal hızda ninja'ya doğru hareket et
      speed = 150.0;
      position.add(direction * speed * dt);
    }
  }

  @override
  void performAttack() {
    // Ninja kamuflajda değilse hasar ver
    if (!game.ninja.isInCamouflage) {
      game.ninja.takeDamage(attackDamage);

      // Saldırı efekti için enemy'yi kısa süre büyüt
      final originalRadius = radius;
      radius = originalRadius * 1.3;

      // 0.1 saniye sonra normal boyuta döndür
      Future.delayed(const Duration(milliseconds: 100), () {
        if (isMounted) {
          radius = originalRadius;
        }
      });

      // Saldırı sırasında renk değiştir
      final originalColor = paint.color;
      paint.color = Colors.orange.withOpacity(0.9);

      Future.delayed(const Duration(milliseconds: 100), () {
        if (isMounted) {
          paint.color = originalColor;
        }
      });
    }
  }
}
