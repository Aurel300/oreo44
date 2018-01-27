package game;

enum EntityType {
  Player;
  Bullet(player:Bool);
  Enemy;
  Pickup;
}
