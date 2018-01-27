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
  
  public function new(game:Game, type:EntityType) {
    this.game = game;
    this.type = type;
  }
  
  public function tick():Void {
    remove = true;
  }
}
