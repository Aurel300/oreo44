package game;

class Bullet extends Entity {
  public var player:Bool;
  
  public function new(player:Bool, x:Float, y:Float) {
    super(Bullet(player));
    this.player = player;
    this.x = x;
    this.y = y;
    sprite = game.render.createSprite("bullet" + (player ? " player" : ""));
  }
  
  override public function tick():Void {
    y += player ? -8 : 3;
    if (y < -Game.LETTER || y > Game.SCREEN + Game.LETTER) remove = true;
    super.tick();
  }
}
