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
  
  public function new(type:EntityType) {
    this.game = Main.game;
    this.type = type;
  }
  
  public function tick():Void {
    if (sprite != null) {
      sprite.x = x;
      sprite.y = y;
    }
  }
  
  public function destroy():Void {
    if (sprite != null) {
      game.render.removeSprite(sprite);
      sprite = null;
    }
  }
}
