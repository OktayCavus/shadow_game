import 'dart:math';
import 'package:flame/components.dart';
import 'package:shadowbladerush/game.dart';
import 'package:shadowbladerush/actors/enemy.dart';
import 'package:shadowbladerush/actors/melee_enemy.dart';
import 'package:shadowbladerush/actors/ranged_enemy.dart';

class SpawnManager extends Component with HasGameReference<ShadowBladeRush> {
  final Random random = Random();

  double spawnTimer = 0.0;
  double spawnInterval = 3.0; // Her 3 saniyede bir düşman spawn et
  int maxEnemiesOnScreen = 4; // Ekranda maksimum düşman sayısı

  @override
  void update(double dt) {
    super.update(dt);

    spawnTimer += dt;

    // Eğer spawn süresi dolmuşsa ve ekrandaki düşman sayısı max değerin altındaysa
    final enemyCount = game.children.whereType<Enemy>().length;

    if (spawnTimer >= spawnInterval && enemyCount < maxEnemiesOnScreen) {
      spawnRandomEnemy();
      spawnTimer = 0.0;
    }
  }

  void spawnRandomEnemy() {
    final spawnPosition = getRandomSpawnPosition();

    // %50 - %50 şansla MeleeEnemy ya da RangedEnemy spawn et
    final enemyType = random.nextInt(2);

    Enemy enemy;
    if (enemyType == 0) {
      enemy = MeleeEnemy(startPosition: spawnPosition);
    } else {
      enemy = RangedEnemy(startPosition: spawnPosition);
    }

    game.add(enemy);
  }

  Vector2 getRandomSpawnPosition() {
    final gameSize = game.size;
    const spawnMargin = 100.0;

    final spawnSide = random.nextInt(4);

    switch (spawnSide) {
      case 0: // Üst kenar
        return Vector2(random.nextDouble() * gameSize.x, -spawnMargin);
      case 1: // Sağ kenar
        return Vector2(
            gameSize.x + spawnMargin, random.nextDouble() * gameSize.y);
      case 2: // Alt kenar
        return Vector2(
            random.nextDouble() * gameSize.x, gameSize.y + spawnMargin);
      case 3: // Sol kenar
        return Vector2(-spawnMargin, random.nextDouble() * gameSize.y);
      default:
        return Vector2(gameSize.x / 2, gameSize.y / 2);
    }
  }

  // Manuel spawn için (test amaçlı)
  void forceSpawnMelee() {
    final spawnPosition = getRandomSpawnPosition();
    final enemy = MeleeEnemy(startPosition: spawnPosition);
    game.add(enemy);
  }

  void forceSpawnRanged() {
    final spawnPosition = getRandomSpawnPosition();
    final enemy = RangedEnemy(startPosition: spawnPosition);
    game.add(enemy);
  }

  void resetState() {
    // Tüm düşmanları kaldır
    final enemies = game.children.whereType<Enemy>().toList();
    for (final enemy in enemies) {
      enemy.removeFromParent();
    }

    // Timer'ı sıfırla
    spawnTimer = 0.0;
  }

  // Zorluk seviyesini artır
  void increaseDifficulty() {
    maxEnemiesOnScreen = (maxEnemiesOnScreen + 1).clamp(1, 8);
    spawnInterval = (spawnInterval * 0.9).clamp(1.0, 3.0);
  }
}
