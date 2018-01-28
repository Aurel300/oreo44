package game;

class Player extends Entity {
  static var JOY_SPEED = 5.0;
  
  public function new() {
    super(Player);
    x = Game.SCREEN_LETTER / 2;
    y = Game.SCREEN * .75;
    sprite = game.render.createSprite("player");
  }
  
  override public function tick():Void {
    switch (game.state) {
      case Joystick(x, y, z):
      this.x += x * JOY_SPEED;
      this.y += y * JOY_SPEED;
      case Wheel(a, _, _):
      this.x += a;
      this.y = (this.y * 11 + Game.SCREEN_LETTER / 2) / 12;
      case Slider(i):
      this.y += i;
      case None:
    }
    x = (x < 10 ? 10 : (x > Game.SCREEN_LETTER - 10 ? Game.SCREEN_LETTER - 10 : x));
    y = (y < 80 ? 80 : (y > Game.SCREEN - 10 ? Game.SCREEN - 10 : y));
    super.tick();
  }
}
