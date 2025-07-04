import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shadowbladerush/game.dart';
import 'package:shadowbladerush/overlays/abilities_overlay.dart';
import 'package:shadowbladerush/overlays/game_over_overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const ShadowBladeRushApp());
}

class ShadowBladeRushApp extends StatefulWidget {
  const ShadowBladeRushApp({super.key});

  @override
  State<ShadowBladeRushApp> createState() => _ShadowBladeRushAppState();
}

class _ShadowBladeRushAppState extends State<ShadowBladeRushApp> {
  late ShadowBladeRush game;
  bool showGameOver = false;

  @override
  void initState() {
    super.initState();
    game = ShadowBladeRush();
    game.onGameOver = _showGameOver;
  }

  void _showGameOver() {
    setState(() {
      showGameOver = true;
    });
  }

  void _hideGameOver() {
    setState(() {
      showGameOver = false;
    });
  }

  void _onRetry() {
    _hideGameOver();
    // // Oyunu yeniden başlat
    // setState(() {
    //   game = ShadowBladeRush();
    //   game.onGameOver = _showGameOver;
    // });
    game.resetGame();
  }

  void _onMainMenu() {
    _hideGameOver();
    // Ana menüye dön (şu an için oyunu yeniden başlat)
    setState(() {
      game = ShadowBladeRush();
      game.onGameOver = _showGameOver;
    });
  }

  void _onQuit() {
    // Uygulamayı kapat
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          GameWidget<ShadowBladeRush>.controlled(
            gameFactory: () => game,
          ),
          AbilitiesOverlay(game: game),
          if (showGameOver)
            GameOverOverlay(
              onRetry: _onRetry,
              onMainMenu: _onMainMenu,
              onQuit: _onQuit,
            ),
        ],
      ),
    );
  }
}
