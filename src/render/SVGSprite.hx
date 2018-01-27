package render;

import js.html.*;

class SVGSprite extends Sprite {
  var rx:Float;
  var ry:Float;
  var bw:Float;
  var bh:Float;
  var el:DOMElement;
  
  public function new(type:String, id:Int) {
    super(type, id);
    bw = 15;
    bh = 15;
    el = JSCompat.create("ent player");
    SVGRenderer.svg.appendChild(el);
  }
  
  override function get_x():Float {
    return rx;
  }
  override function set_x(x:Float):Float {
    el.style.left = '${x - bw}px';
    return rx = x;
  }
  
  override function get_y():Float {
    return ry;
  }
  override function set_y(y:Float):Float {
    el.style.top = '${y - bh}px';
    return ry = y;
  }
}
