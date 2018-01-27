package game;

class Player extends Entity {
  static var JOY_SPEED = 5.0;
  
  public function new(game:Game) {
    super(game, Player);
    sprite = game.render.createSprite("player");
  }
  
  override public function tick():Void {
    switch (game.state) {
      case Joystick(x, y):
      this.x += x * JOY_SPEED;
      this.y += y * JOY_SPEED;
      case Wheel(a):
      this.x += a;
      case Slider(i):
      this.y += i;
      case None:
    }
    sprite.x = x;
    sprite.y = y;
  }
}
