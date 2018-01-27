package input;

import js.*;

class KeyboardInputMethod extends InputMethod {
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
  
  private function handleKey(down:Bool, e:KeyboardEvent):Void {
    var code = untyped __js__("{0}.code", e);
    if (!state.exists(code)) return;
    state[code] = down;
  }
  
  public function new() {
    JSCompat.addEventListener(Browser.document.body, "keydown", handleKey.bind(true));
    JSCompat.addEventListener(Browser.document.body, "keyup", handleKey.binf(false));
  }
  
  public function tick():InputState {
    type = (if (state["KeyA"]) 1
      else if (state["KeyS"]) 2
      else if (state["KeyD"]) 3
      else type);
    return (switch (type) {
        case 1: Joystick(0, 0);
        case 2: Wheel(0);
        case 3: Slider(0);
      });
  }
}
