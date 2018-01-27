package render;

import js.html.*;
import game.LevelState;

class SVGRenderer implements Renderer {
  public static var svg:HtmlElement;
  public static var letter:HtmlElement;
  var sprites = new Map<Int, SVGSprite>();
  var spriteId = 0;
  
  public function new(id:String) {
    svg = cast JSCompat.element(id);
    letter = cast JSCompat.element("letterbox");
  }
  
  public function mode(s:LevelState):Void {
    svg.className = (switch (s) {
        case Vertical: "";
        case Horizontal: "horizontal";
        case Plane: "plane";
      });
  }
  
  public function createSprite(type:String):Sprite {
    var s = new SVGSprite(type, spriteId);
    sprites[spriteId++] = s;
    return s;
  }
  
  public function removeSprite(s:Sprite):Void {
    var sprite = sprites[s.id];
    letter.removeChild(sprite.el);
  }
  
  public function tick():Void {
    
  }
}
