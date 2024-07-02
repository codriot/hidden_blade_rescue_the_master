import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:hidden_blade_rescue_the_master/component/player.dart';
import 'package:hidden_blade_rescue_the_master/levels/level.dart';

class ShinobisAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  ///  game code here
  late final CameraComponent cam;
  final player = Player(
    character: 'Samurai',
  );
  late JoystickComponent joystick;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  FutureOr<void> onLoad() async {
    final world = Level(levelName: 'Level-02', player: player);

    // Load all images into cache
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: world);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    addJoystick();
    return super.onLoad();
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/Knob.png'))),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }
}
