import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flappy_bird/component/background.dart';
import 'package:flutter_flappy_bird/component/bird.dart';
import 'package:flutter_flappy_bird/component/ground.dart';
import 'package:flutter_flappy_bird/component/pipe_group.dart';
import 'package:flutter_flappy_bird/game/config.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  late TextComponent score;
  Timer interval = Timer(Config.pipeInterval, repeat: true);
  bool isHit = false;
  @override
  FutureOr<void> onLoad() async {
    addAll([
      Background(),
      Ground(),
      bird = Bird(),
      score = buildScore(),
    ]);
    interval.onTick = () => add(PipeGroup());
    return super.onLoad();
  }

  @override
  void onTap() {
    bird.fly();
    super.onTap();
  }

  TextComponent buildScore() {
    return TextComponent(
      text: "Score : 0",
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold, fontFamily: "Game"),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
    score.text = "Score : ${bird.score}";
  }
}
