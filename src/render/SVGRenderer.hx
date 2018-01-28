package render;

import js.html.*;
import game.LevelState;

class SVGRenderer implements Renderer {
  public static var svg:HtmlElement;
  public static var letter:HtmlElement;
  public static var hp:HtmlElement;
  var sprites = new Map<Int, SVGSprite>();
  var spriteId = 0;
  var playCls = false;
  var modeCls = "";
  
  function updateClass():Void {
    svg.className = modeCls + " " + (playCls ? "game" : "");
  }
  
  public function new(id:String) {
    svg = cast JSCompat.element(id);
    letter = cast JSCompat.element("letterbox");
    hp = cast JSCompat.qs("#hp div div");
  }
  
  public function mode(s:LevelState):Void {
    modeCls = (switch (s) {
        case Transition(_, Vertical) | Vertical: "";
        case Transition(_, Horizontal) | Horizontal: "horizontal";
        case Transition(_, Plane) | Plane: "plane";
        case _: "";
      });
    updateClass();
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
  
  public function health(h:Float):Void {
    hp.style.top = '${(1 - h) * 100}%';
  }
  
  public function playing(p:Bool, go:Bool):Void {
    playCls = p;
    updateClass();
    if (!p && go) {
      JSCompat.qs("h1").innerHTML = "game over!";
    }
  }
}
