import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:hidden_blade_rescue_the_master/component/collision_block.dart';
import 'package:hidden_blade_rescue_the_master/component/player.dart';

class Level extends World {
  final String levelName;
  //! Shinobi is broken, it's not working fix it
  final Player player;
  Level({required this.levelName, required this.player});

  late TiledComponent level;
  List<CollisionBlock> collissionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointsLayer != null) {
      for (var spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            print('Playeri bulduk');
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);

            break;
          default:
        }
      }
    }

    final collissionLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collissionLayer != null) {
      for (var collission in collissionLayer.objects) {
        switch (collission.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collission.x, collission.y),
              size: Vector2(collission.width, collission.height),
              isPlatform: true,
            );
            collissionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collission.x, collission.y),
              size: Vector2(collission.width, collission.height),
            );
            collissionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collissionBlocks;

    // TODO: implement onLoad
    return super.onLoad();
  }
}
