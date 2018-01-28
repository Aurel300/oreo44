package game;

class Feature extends Entity {
  public var up:Bool;
  public var dist:Float;
  
  public function new(up:Bool, dist:Float) {
    super(Feature);
    this.up = up;
    this.dist = dist;
    this.x = dist * Game.SCREEN_LETTER;
    this.y = -50;
    sprite = game.render.createSprite("feature" + (up ? " up" : ""));
  }
  
  override public function tick():Void {
    y += 2;
    if (y > Game.SCREEN + Game.LETTER) remove = true;
    super.tick();
  }
}
