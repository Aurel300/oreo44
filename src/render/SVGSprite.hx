package render;

import js.html.*;

class SVGSprite extends Sprite {
  var rx:Float;
  var ry:Float;
  var baseCls:String;
  public var el:DOMElement;
  
  public function new(type:String, id:Int) {
    super(type, id);
    baseCls = 'ent $type';
    el = JSCompat.create(baseCls);
    el.innerHTML = (switch (type) {
        case "player": "▲";
        case "bullet": "▼";
        case "bullet playerbullet": "▲";
        case _: "";
      });
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
  
  override function set_hurting(h:Bool):Bool {
    el.className = baseCls + (h ? " hurting" : "");
    return h;
  }
}
