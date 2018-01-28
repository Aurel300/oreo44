package game;

enum EntityType {
  Player;
  Bullet(player:Bool);
  Enemy;
  Feature;
  Particle;
  BG;
  Pickup;
}
