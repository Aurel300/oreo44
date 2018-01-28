package game;

class BG extends Entity {
  public function new() {
    super(BG);
    x = Math.random() * Game.SCREEN_LETTER;
    y = -150;
    sprite = game.render.createSprite("bg bg" + Math.floor(Math.random() * 4));
  }
  
  override public function tick():Void {
    y += 2;
    if (y > Game.SCREEN + Game.LETTER * 2) remove = true;
    super.tick();
  }
}
