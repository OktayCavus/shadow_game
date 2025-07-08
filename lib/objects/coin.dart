import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:shadowbladerush/actors/ninja.dart';
import 'package:shadowbladerush/game.dart';

class Coin extends SpriteComponent
    with HasGameReference<ShadowBladeRush>, CollisionCallbacks {
  Coin({required Vector2 position})
      : super(
          position: position,
          size: Vector2(32, 32),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('coin.png');
    add(CircleHitbox()); // Daire şeklinde çarpışma kutusu
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    // Ninja ile çarpıştıysa
    if (other is Ninja) {
      // (Opsiyonel) game.coins += 1;
      removeFromParent();
    }
  }
}
