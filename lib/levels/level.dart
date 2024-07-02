import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:hidden_blade_rescue_the_master/component/player.dart';

class Level extends World {
  final String levelName;
  //! Shinobi is broken, it's not working fix it
  final Player player;
  Level({required this.levelName, required this.player});

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');
    for (var spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          print('Playeri bulduk');
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);

          break;
        default:
      }
    }

    // TODO: implement onLoad
    return super.onLoad();
  }
}
