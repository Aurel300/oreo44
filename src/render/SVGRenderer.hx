package render;

import js.html.svg.SVGElement;

class SVGRenderer implements Renderer {
  public static var svg:SVGElement;
  var sprites = new Map<Int, Sprite>();
  var spriteId = 0;
  
  public function new(id:String) {
    svg = cast JSCompat.element(id);
  }
  
  public function createSprite(type:String):Sprite {
    var s = new SVGSprite(type, spriteId++);
    return s;
  }
  
  public function removeSprite(s:Sprite):Void {
    var sprite = sprites[s.id];
  }
  
  public function tick():Void {
    
  }
}
