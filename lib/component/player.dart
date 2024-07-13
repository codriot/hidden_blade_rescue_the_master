import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:hidden_blade_rescue_the_master/component/collision_block.dart';
import 'package:hidden_blade_rescue_the_master/component/custom_hitbox.dart';
import 'package:hidden_blade_rescue_the_master/component/utils.dart';
import 'package:hidden_blade_rescue_the_master/shinobis_adventure.dart';

enum PlayerState { idle, run, jump, attack, dead }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<ShinobisAdventure>, KeyboardHandler {
  Player({position, this.character = 'Shinobi'}) : super(position: position);
  String character;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  final double steptime = 0.05;

  final double _gravity = 9.8;
  final double _jumpForce = 460;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero(); // initial velocity
  bool isOnGround = false;
  bool hasJumped = false;
  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 20,
    offsetY: 8,
    width: 28,
    height: 56,
  );

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    _updatePlayerState();
    _checkHorizontalCollisions();
    _applyGravity(dt);
    _checkVerticalCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    final isJumpKeyPressed = keysPressed.contains(LogicalKeyboardKey.space);

    // final isJumpKeyPressed = keysPressed.contains(LogicalKeyboardKey.space);

    horizontalMovement = isLeftKeyPressed
        ? -1
        : isRightKeyPressed
            ? 1
            : 0;

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
    current = PlayerState.idle;
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
    if (hasJumped) _playerJump(dt);

    // ? frictionu kaldırdım kodumu düzenlerken proje sonunda ekleyeceğim
    velocity.x = horizontalMovement * moveSpeed;
    // ? velocity = Vector2(dirX, 0.0);
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    hasJumped = false;
    isOnGround = false;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
      // current = PlayerState.run;
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
      // current = PlayerState.idle;
    }

    if (velocity.x > 0 || velocity.x < 0) {
      playerState = PlayerState.run;
    }
    current = playerState;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }
}
