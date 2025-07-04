import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onMainMenu;
  final VoidCallback onQuit;

  const GameOverOverlay({
    super.key,
    required this.onRetry,
    required this.onMainMenu,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Game over background image
        // Positioned.fill(
        //   child: Image.asset(
        //     'assets/images/game_over2.png', // Senin yüklediğin görsel
        //     fit: BoxFit.fill,
        //   ),
        // ),
        // Saydam arka plan (isteğe bağlı karartma)
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        // Butonlar
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 180),
              _buildButton(context, 'RETRY', onRetry),
              const SizedBox(height: 12),
              _buildButton(context, 'MAIN MENU', onMainMenu),
              const SizedBox(height: 12),
              _buildButton(context, 'QUIT', onQuit),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.yellowAccent,
          side: const BorderSide(color: Colors.red, width: 2),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
