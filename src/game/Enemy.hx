package game;

class Enemy extends Entity {
  var hp = 2;
  var hurting = 0;
  
  public function new() {
    super(Enemy);
    sprite = game.render.createSprite("enemy");
  }
  
  public function hurt() {
    hp--;
    if (hp <= 0) {
      for (i in 0...10) game.addEntity(new Particle(Explosion, x, y));
      remove = true;
    } else {
      for (i in 0...5) game.addEntity(new Particle(Spark, x, y));
      hurting = 10;
    }
  }
  
  override public function tick():Void {
    if (Math.random() < 0.01) {
      game.addEntity(new Bullet(false, x, y));
    }
    sprite.hurting = hurting > 0;
    if (hurting > 0) hurting--;
    super.tick();
  }
}
