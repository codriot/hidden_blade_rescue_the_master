import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform = false;
// CollisionBlock({required Vector2 position, required Vector2 size}) {
  CollisionBlock({
    position,
    size,
    this.isPlatform = false,
  }) : super(position: position, size: size);
}
