import game.*;
import input.*;
import render.*;

class Main {
  public static function main() js.Browser.window.onload = init;
  
  public static var input:InputMethod;
  public static var game:Game;
  public static var render:Renderer;
  
  public static function init():Void {
    // input = new CameraInputMethod();
    input = new KeyboardInputMethod();
    game = new Game();
    render = new SVGRenderer();
  }
}
