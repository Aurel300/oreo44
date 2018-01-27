package input;

import js.*;
import js.html.*;

class KeyboardInputMethod implements InputMethod {
  var state = [
       "Space" => false
      ,"ArrowLeft" => false
      ,"ArrowUp" => false
      ,"ArrowRight" => false
      ,"ArrowDown" => false
      ,"KeyA" => false
      ,"KeyS" => false
      ,"KeyD" => false
    ];
  var type:Int = 0;
  
  function handleKey(down:Bool, e:KeyboardEvent):Void {
    var code = untyped __js__("{0}.code", e);
    if (!state.exists(code)) return;
    state[code] = down;
  }
  
  public function new() {
    JSCompat.addEventListener(Browser.document.body, "keydown", handleKey.bind(true));
    JSCompat.addEventListener(Browser.document.body, "keyup", handleKey.bind(false));
  }
  
  public function tick():InputState {
    type = (if (state["KeyA"]) 1
      else if (state["KeyS"]) 2
      else if (state["KeyD"]) 3
      else type);
    var x = state["ArrowLeft"] ? -1 : (state["ArrowRight"] ? 1 : 0);
    return (switch (type) {
        case 1:
        var y = state["ArrowUp"] ? -1 : (state["ArrowDown"] ? 1 : 0);
        Joystick(x, y);
        case 2: Wheel(x);
        case 3: Slider(x * .5 + 1);
        case _: None;
      });
  }
}
