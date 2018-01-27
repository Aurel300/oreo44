package game;

class Enemy extends Entity {
  public function new() {
    super(Enemy);
    sprite = game.render.createSprite("enemy");
  }
  
  public function hurt() {
    remove = true;
  }
  
  override public function tick():Void {
    if (Math.random() < 0.01) {
      game.addEntity(new Bullet(false, x, y));
    }
    super.tick();
  }
}
