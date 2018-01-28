package game;

class Pickup extends Entity {
  var vx:Float = 0;
  
  public function new(x:Float, y:Float) {
    super(Pickup);
    this.x = x;
    this.y = y;
    sprite = game.render.createSprite("pickup");
  }
  
  override public function tick():Void {
    x += vx;
    vx += Math.random() * 0.01 - 0.005;
    y += 2;
    if (y > Game.SCREEN + Game.LETTER * 2) remove = true;
    super.tick();
  }
}
