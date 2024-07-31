import 'package:flutter/material.dart';
import 'package:flutter_flappy_bird/game/assets.dart';
import 'package:flutter_flappy_bird/game/flappy_bird_game.dart';

class GameOverScreen extends StatelessWidget {
  final FlappyBirdGame game;
  static const String id = "gameOver";
  const GameOverScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Score: ${game.bird.score}",
              style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Game"),
            ),
            Image.asset(Assets.gameOver),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: onRestart,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                    child: Text(
                  "Restart",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onRestart() {
    game.bird.reset();
    game.overlays.remove("gameOver");
    game.resumeEngine();
  }
}
