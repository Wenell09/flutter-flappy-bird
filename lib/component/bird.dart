import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flappy_bird/game/assets.dart';
import 'package:flutter_flappy_bird/game/bird_movement.dart';
import 'package:flutter_flappy_bird/game/config.dart';
import 'package:flutter_flappy_bird/game/flappy_bird_game.dart';

class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird();
  int score = 0;

  @override
  FutureOr<void> onLoad() async {
    final birdMid = await gameRef.loadSprite(Assets.birdMid);
    final birdUp = await gameRef.loadSprite(Assets.birdUp);
    final birdDown = await gameRef.loadSprite(Assets.birdDown);

    size = Vector2(50, 40);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    current = BirdMovement.middle;

    sprites = {
      BirdMovement.up: birdUp,
      BirdMovement.middle: birdMid,
      BirdMovement.down: birdDown,
    };

    add(CircleHitbox());

    return super.onLoad();
  }

  void fly() {
    add(
      MoveByEffect(
        Vector2(0, Config.gravity),
        EffectController(duration: 0.2, curve: Curves.decelerate),
        onComplete: () => current = BirdMovement.down,
      ),
    );
    current = BirdMovement.up;
    FlameAudio.play(Assets.flying);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    debugPrint("Collison detected");
    gameOver();
    super.onCollisionStart(intersectionPoints, other);
  }

  void gameOver() {
    game.overlays.add("gameOver");
    gameRef.pauseEngine();
    game.isHit = true;
    FlameAudio.play(Assets.collison);
  }

  void reset() {
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    score = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += Config.birdVelocity * dt;
    if (position.y < 1) {
      gameOver();
    }
  }
}
