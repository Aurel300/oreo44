package game;

class Enemy extends Entity {
  var hp = 1;
  
  public function new() {
    super(Enemy);
    sprite = game.render.createSprite("enemy");
  }
  
  override public function hurt() {
    hp--;
    if (hp <= 0) {
      for (i in 0...10) game.addEntity(new Particle(Explosion, x, y));
      remove = true;
      Game.snd("kill");
      if (Math.random() < 0.02) game.addEntity(new Pickup(x, y));
    }
    super.hurt();
  }
  
  override public function tick():Void {
    if (Math.random() < 0.01) {
      game.addEntity(new Bullet(false, x, y));
    }
    super.tick();
  }
}
