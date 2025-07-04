import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shadowbladerush/actors/ninja.dart';
import 'package:shadowbladerush/managers/spawn_manager.dart';
import 'package:shadowbladerush/overlays/abilities_overlay.dart';

class ShadowBladeRush extends FlameGame {
  late Ninja ninja;
  late SpawnManager spawnManager;

  JoystickComponent? _joystickComponent;

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  bool _hasLoaded = false;
  bool get hasLoaded => _hasLoaded;

  // Game over callback
  VoidCallback? onGameOver;

  @override
  Color backgroundColor() => const Color.fromARGB(255, 104, 101, 124);

  @override
  FutureOr<void> onLoad() async {
    if (Platform.isAndroid || Platform.isIOS) {
      _addJoystick();
    }

    ninja = Ninja(_joystickComponent!);
    add(ninja);

    // Spawn manager'ı ekle
    spawnManager = SpawnManager();
    add(spawnManager);

    if (_joystickComponent != null) {
      camera.viewport.add(_joystickComponent!);
    }

    // Overlay will be managed by GameWidget
    _hasLoaded = true;

    return super.onLoad();
  }

  void _addJoystick() async {
    _joystickComponent = JoystickComponent(
      knob: CircleComponent(
          radius: 16, paint: Paint()..color = Colors.white.withOpacity(.5)),
      background: CircleComponent(
          radius: 60, paint: Paint()..color = Colors.white.withOpacity(0.2)),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    add(_joystickComponent!);
  }

  void pauseGame() {
    if (!_isPaused) {
      _isPaused = true;
      pauseEngine();
    }
  }

  void resumeGame() {
    if (_isPaused) {
      _isPaused = false;
      resumeEngine();
    }
  }

  void togglePause() {
    if (_isPaused) {
      resumeGame();
    } else {
      pauseGame();
    }
  }

  void triggerGameOver() {
    pauseGame();
    onGameOver?.call();
  }

  void resetGame() {
    // Oyunu pause et
    pauseGame();

    // Eğer ninja oyundan kaldırılmışsa tekrar ekle
    if (!children.contains(ninja)) {
      add(ninja);
    }

    // Ninja'nın durumunu sıfırla (can, pozisyon, etc.)
    ninja.resetState();

    // Spawn manager'ı sıfırla (düşmanları temizle)
    spawnManager.resetState();

    // Oyunu devam ettir
    resumeGame();
  }
}
