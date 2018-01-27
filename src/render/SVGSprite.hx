package render;

import js.html.*;

class SVGSprite extends Sprite {
  var rx:Float;
  var ry:Float;
  public var el:DOMElement;
  
  public function new(type:String, id:Int) {
    super(type, id);
    el = JSCompat.create("ent " + type);
    SVGRenderer.letter.appendChild(el);
  }
  
  override function get_x():Float {
    return rx;
  }
  override function set_x(x:Float):Float {
    el.style.left = '${x}px';
    return rx = x;
  }
  
  override function get_y():Float {
    return ry;
  }
  override function set_y(y:Float):Float {
    el.style.top = '${y + 150}px';
    return ry = y;
  }
}
