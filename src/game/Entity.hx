package game;

import render.Sprite;

class Entity {
  public var game:Game;
  public var type:EntityType;
  public var remove:Bool = false;
  public var sprite:Sprite;
  public var x:Float = 0;
  public var y:Float = 0;
  public var z:Float = 0;
  public var hurting = 0;
  
  public function new(type:EntityType) {
    this.game = Main.game;
    this.type = type;
  }
  
  public function tick():Void {
    if (sprite != null) {
      sprite.x = x;
      sprite.y = y;
      sprite.hurting = hurting > 0;
    }
    if (hurting > 0) hurting--;
  }
  
  public function hurt():Void {
    for (i in 0...5) game.addEntity(new Particle(Spark, x, y));
    hurting = 10;
  }
  
  public function destroy():Void {
    if (sprite != null) {
      game.render.removeSprite(sprite);
      sprite = null;
    }
  }
}
