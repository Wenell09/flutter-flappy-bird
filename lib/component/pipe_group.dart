import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flappy_bird/component/pipe.dart';
import 'package:flutter_flappy_bird/game/assets.dart';
import 'package:flutter_flappy_bird/game/config.dart';
import 'package:flutter_flappy_bird/game/flappy_bird_game.dart';
import 'package:flutter_flappy_bird/game/pipe_position.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();
  final _random = Random();

  @override
  FutureOr<void> onLoad() async {
    position.x = gameRef.size.x;
    final heightminusGround = gameRef.size.y - Config.groundHeight;
    final spacing = 100 + _random.nextDouble() * (heightminusGround / 4);
    final centerY =
        spacing + _random.nextDouble() * (heightminusGround - spacing);

    addAll([
      Pipe(height: centerY - spacing / 2, pipePosition: PipePosition.top),
      Pipe(
          height: heightminusGround - (centerY + spacing / 2),
          pipePosition: PipePosition.bottom)
    ]);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;
    if (position.x < -10) {
      removeFromParent();
      updatedScore();
      debugPrint("Removed");
    }
    if (game.isHit) {
      removeFromParent();
      game.isHit = false;
    }
  }

  void updatedScore() {
    gameRef.bird.score += 1;
    FlameAudio.play(Assets.point);
  }
}
