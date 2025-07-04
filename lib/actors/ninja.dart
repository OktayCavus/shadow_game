import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shadowbladerush/game.dart';
import 'package:shadowbladerush/objects/sword.dart';
import 'package:shadowbladerush/actors/enemy.dart';

class Ninja extends SpriteAnimationComponent
    with HasGameReference<ShadowBladeRush> {
  Ninja(this.joystick)
      : super(
          anchor: Anchor.center,
          // paint: Paint()..color = Colors.white.withOpacity(0.9),
          size: Vector2(21.53846153846154, 64),
        );

  final JoystickComponent joystick;

  double maxSpeed = 300.0;
  bool isInCamouflage = false;
  double camouflageTimer = 0.0;
  final double camouflageDuration = 3.0;
  final double maxHealth = 1000.0;
  double health = 1000.0;

  bool isQuickAttacking = false;
  double quickAttackTimer = 0.0;
  final double quickAttackDuration = 0.6;
  Vector2? quickAttackDirection;
  final double quickAttackSpeed = 500.0;

  bool isThrowingAttack = false;
  double throwAttackTimer = 0.0;
  final double throwAttackDuration = 1.0; // 10 frame * 0.1 stepTime

  Vector2 lastDirection = Vector2(1, 0);

  // Yön takibi için değişken (true = sağ, false = sol)
  bool facingRight = true;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(game.size.x / 2, game.size.y / 2);

    animation = await game.loadSpriteAnimation(
        'stand.png',
        SpriteAnimationData.sequenced(
          amount: 13,
          textureSize: Vector2(21.53846153846154, 64),
          stepTime: 0.1,
        ));

    // radius = 35;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isThrowingAttack) {
      throwAttackTimer += dt;
      if (throwAttackTimer >= throwAttackDuration) {
        isThrowingAttack = false;
        throwAttackTimer = 0.0;
        // Stand animasyonuna geri dön
        _loadStandAnimation();
      }
      return; // Throw attack sırasında diğer hareketleri engelle
    }

    if (isQuickAttacking) {
      quickAttackTimer += dt;
      if (quickAttackDirection != null) {
        position.add(quickAttackDirection! * quickAttackSpeed * dt);
      }

      // QuickAttack sırasında düşmanlarla çarpışma kontrolü
      _checkQuickAttackCollisions();

      if (quickAttackTimer >= quickAttackDuration) {
        isQuickAttacking = false;
        quickAttackTimer = 0.0;
        quickAttackDirection = null;
        // Stand animasyonuna geri dön
        _loadStandAnimation();
      }
    } else {
      if (joystick.direction != JoystickDirection.idle) {
        position.add(joystick.relativeDelta * maxSpeed * dt);

        lastDirection = joystick.relativeDelta.normalized();

        // Yön değişikliğini kontrol et
        bool newFacingRight = lastDirection.x >= 0;
        if (newFacingRight != facingRight) {
          facingRight = newFacingRight;
          _loadStandAnimation(); // Yön değiştiğinde animasyonu güncelle
        }
      }
    }

    if (isInCamouflage) {
      camouflageTimer += dt;
      if (camouflageTimer >= camouflageDuration) {
        toggleCamouflage();
      }
    }

    if (position.x > game.size.x) {
      position.x = 0;
    }

    if (position.x < 0) {
      position.x = game.size.x;
    }

    if (position.y > game.size.y) {
      position.y = 0;
    }

    if (position.y < 0) {
      position.y = game.size.y;
    }
  }

  void quickAttack() async {
    if (isQuickAttacking) return;

    isQuickAttacking = true;
    quickAttackTimer = 0.0;

    quickAttackDirection = lastDirection.clone();

    // Quick attack animasyonunu yükle
    String quickAttackSprite =
        facingRight ? 'quick_attack.png' : 'quick_attack_2.png';

    animation = await game.loadSpriteAnimation(
      quickAttackSprite,
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2(53.3, 44),
        stepTime: 0.05, // Hızlı animasyon için daha kısa stepTime
      ),
    );

    // Quick attack animasyonu sırasında boyutu güncelle
    size = Vector2(53.3, 44);
  }

  void toggleCamouflage() {
    if (isInCamouflage) return;

    isInCamouflage = true;
    camouflageTimer = 0.0;
    paint.color = Colors.white.withOpacity(0.3);

    Future.delayed(const Duration(seconds: 3), () {
      isInCamouflage = false;
      paint.color = Colors.white.withOpacity(0.9);
    });
  }

  void throwSword() async {
    if (isThrowingAttack) return; // Zaten saldırı animasyonu çalışıyorsa çık

    Vector2 direction;

    // En yakın düşmanı bul
    final nearestEnemy = findNearestEnemy();

    if (nearestEnemy != null) {
      // En yakın düşmana doğru yön hesapla
      direction = (nearestEnemy.position - position).normalized();
    } else {
      // Düşman yoksa son hareket yönünü kullan
      direction = lastDirection.clone();
    }

    // Throw attack durumunu başlat
    isThrowingAttack = true;
    throwAttackTimer = 0.0;

    // Range attack animasyonunu yükle
    String rangeAttackSprite =
        facingRight ? 'range_attack.png' : 'range_attack_2.png';

    animation = await game.loadSpriteAnimation(
      rangeAttackSprite,
      SpriteAnimationData.sequenced(
        amount: 10,
        textureSize: facingRight ? Vector2(40.2, 61) : Vector2(40.7, 61),
        stepTime: 0.1,
        // loop: false,
      ),
    );

    // Range attack animasyonu sırasında boyutu güncelle
    size = facingRight ? Vector2(40.2, 61) : Vector2(40.7, 61);

    final sword = Sword(
      direction: direction,
      startPosition: position,
    );

    game.add(sword);
  }

  // Stand animasyonunu yükleyen yardımcı metod
  Future<void> _loadStandAnimation() async {
    String spritePath = facingRight ? 'stand.png' : 'stand_2.png';

    animation = await game.loadSpriteAnimation(
        spritePath,
        SpriteAnimationData.sequenced(
          amount: 13,
          textureSize: Vector2(21.53846153846154, 64),
          stepTime: 0.1,
        ));

    // Stand animasyonu için boyutu geri getir
    size = Vector2(21.53846153846154, 64);
  }

  // En yakın düşmanı bulan metod
  Enemy? findNearestEnemy() {
    final enemies = game.children.whereType<Enemy>().toList();

    if (enemies.isEmpty) {
      return null;
    }

    Enemy? nearestEnemy;
    double shortestDistance = double.infinity;

    for (final enemy in enemies) {
      final distance = position.distanceTo(enemy.position);
      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestEnemy = enemy;
      }
    }

    return nearestEnemy;
  }

  void takeDamage(double damage) {
    health -= damage;
    health = health.clamp(0.0, maxHealth);
    if (health <= 0) {
      game.triggerGameOver();
      // removeFromParent();
    }
  }

  void resetState() {
    // Sağlığı tam yap
    health = maxHealth;

    // Pozisyonu merkeze al - game.size kontrol et
    if (game.size.x > 0 && game.size.y > 0) {
      position = Vector2(game.size.x / 2, game.size.y / 2);
    } else {
      // Varsayılan pozisyon
      position = Vector2(400, 300);
    }

    // Kamuflaj durumunu sıfırla
    isInCamouflage = false;
    camouflageTimer = 0.0;
    paint.color = Colors.white.withOpacity(0.9);

    // Hızlı saldırı durumunu sıfırla
    isQuickAttacking = false;
    quickAttackTimer = 0.0;
    quickAttackDirection = null;

    // Throw saldırı durumunu sıfırla
    isThrowingAttack = false;
    throwAttackTimer = 0.0;

    // Son yönü sıfırla
    lastDirection = Vector2(1, 0);
    angle = 0.0;

    // Yön durumunu sıfırla
    facingRight = true;

    // Stand animasyonuna geri dön
    _loadStandAnimation();
  }

  // QuickAttack sırasında düşmanlarla çarpışma kontrolü
  void _checkQuickAttackCollisions() {
    final enemies = game.children.whereType<Enemy>().toList();

    for (final enemy in enemies) {
      final distance = position.distanceTo(enemy.position);
      if (distance < (size.x + enemy.radius)) {
        // Çarpışma gerçekleşti - düşmana hasar ver
        enemy.takeDamage(80.0);

        // QuickAttack devam etsin, durmasın
        // Birden fazla düşmana hasar verebilir
      }
    }
  }
}
