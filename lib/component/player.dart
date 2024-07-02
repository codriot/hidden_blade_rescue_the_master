import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:hidden_blade_rescue_the_master/shinobis_adventure.dart';

enum PlayerState { idle, run, jump, attack, dead }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<ShinobisAdventure>, KeyboardHandler {
  Player({position, this.character = 'Fighter'}) : super(position: position);
  String character;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  final double steptime = 0.05;

  PlayerDirection direction = PlayerDirection.none;
  bool isFacingRight = true;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero(); // initial velocity

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    // final isJumpKeyPressed = keysPressed.contains(LogicalKeyboardKey.space);

    if (isLeftKeyPressed && isRightKeyPressed) {
      direction = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      direction = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      direction = PlayerDirection.right;
    } else {
      direction = PlayerDirection.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimation() {
    idleAnimation = _spriteanimation(amount: 6, action: 'Idle3');

    runAnimation = _spriteanimation(amount: 8, action: 'Run2');

// list of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.run: runAnimation,
    };
    // Set the initial state of the player
    current = PlayerState.run;
  }

  SpriteAnimation _spriteanimation(
      {required String action, required int amount}) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('characters/$character/$action.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: steptime,
        textureSize: Vector2.all(64),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0;
    const double friction = 0.82;

    switch (direction) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.run;
        dirX = -moveSpeed;

        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.run;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        dirX = velocity.x * friction;
        break;
      default:
    }
    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
