package game;

import js.*;
import input.InputMethod;
import input.InputState;
import render.Renderer;

class Game {
  public var input:InputMethod;
  public var render:Renderer;
  public var pauseFrames:Int;
  public var entities:Array<Entity>;
  public var state:InputState;
  
  public function new(input:InputMethod, render:Renderer) {
    this.input = input;
    this.render = render;
    Browser.window.requestAnimationFrame(tick);
    trace("?");
    restart();
  }
  
  public function restart():Void {
    pauseFrames = 0;
    entities = [
        new Player(this)
      ];
  }
  
  function tick(e):Void {
    Browser.window.requestAnimationFrame(tick);
    if (pauseFrames > 0) {
      pauseFrames--;
      return;
    }
    state = input.tick();
    entities = [ for (e in entities) {
        e.tick();
        if (e.remove) continue;
        e;
      } ];
    entities.sort(entitySort);
    render.tick();
  }
  
  function entitySort(a:Entity, b:Entity):Int {
    return a.z < b.z ? -1 : 1;
  }
}
