import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:hidden_blade_rescue_the_master/component/level.dart';
import 'package:hidden_blade_rescue_the_master/component/player.dart';

class ShinobisAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  ///  game code here
  late final CameraComponent cam;
  final player = Player(
      // character: 'Samurai',
      );
  late JoystickComponent joystick;
  bool showControls = false;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  FutureOr<void> onLoad() async {
    final world = Level(levelName: 'Level-01', player: player);

    // Load all images into cache
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: world);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    if (showControls) {
      addJoystick();
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 100,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        // player.direction = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        // player.direction = PlayerDirection.right;
        break;
      case JoystickDirection.up:
        break;

      default:
        player.horizontalMovement = 0;
        // player.direction = PlayerDirection.none;
        break;
    }
  }
}
