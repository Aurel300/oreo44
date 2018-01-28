package game;

import js.*;
import input.InputMethod;
import input.InputState;
import render.Renderer;

class Game {
  public static inline var SCREEN = 600;
  public static inline var LETTER = 100;
  public static inline var SCREEN_HALF = SCREEN / 2;
  public static inline var SCREEN_LETTER = SCREEN - 2 * LETTER;
  public static inline var SCREEN_LETTER_HALF = SCREEN_LETTER / 2;
  
  public var input:InputMethod;
  public var render:Renderer;
  public var pauseFrames:Int;
  public var entities:Array<Entity>;
  public var entityTypes:Map<EntityType, Array<Entity>>;
  public var state:InputState;
  public var level:Level;
  public var cooldown:Int;
  public var player:Player;
  
  public function new(input:InputMethod, render:Renderer) {
    Main.game = this;
    this.input = input;
    this.render = render;
    Browser.window.requestAnimationFrame(tick);
    restart();
  }
  
  public function restart():Void {
    pauseFrames = 0;
    entities = [
        player = new Player()
      ];
    entityTypes = [
         Player => []
        ,Bullet(false) => []
        ,Bullet(true) => []
        ,Enemy => []
        ,Pickup => []
        ,Feature => []
        ,Particle => []
      ];
    level = new Level(this);
    cooldown = 0;
  }
  
  public function addEntity(e:Entity):Void {
    entities.push(e);
    entityTypes[e.type].push(e);
  }
  
  function tick(e):Void {
    Browser.window.requestAnimationFrame(tick);
    if (pauseFrames > 0) {
      pauseFrames--;
      return;
    }
    state = input.tick();
    level.tick();
    if (cooldown > 0) cooldown--;
    if (cooldown % 3 == 0) {
      addEntity(new Particle(Thruster, player.x, player.y));
    }
    switch (level.state) {
      case Vertical:
      if (cooldown == 0) {
        addEntity(new Bullet(true, player.x, player.y));
      }
      case _:
    }
    if (cooldown == 0) cooldown = 6;
    for (b in entityTypes[EntityType.Bullet(true)]) {
      for (e in entityTypes[EntityType.Enemy]) {
        if (collision(b, e, 5, 10)) {
          b.remove = true;
          (cast e:Enemy).hurt();
        }
      }
    }
    for (b in entityTypes[EntityType.Bullet(false)]) {
      if (collision(b, player, 15, 15)) {
        b.remove = true;
      }
    }
    entities = [ for (e in entities) {
        e.tick();
        if (e.remove) {
          entityTypes[e.type].remove(e);
          e.destroy();
          continue;
        }
        e;
      } ];
    //entities.sort(entitySort);
    render.tick();
  }
  
  function collision(a:Entity, b:Entity, w:Float, h:Float):Bool {
    var dx = a.x - b.x;
    var dy = a.y - b.y;
    return (dx >= -w && dx <= w && dy >= -h && dy <= h);
  }
  
  function entitySort(a:Entity, b:Entity):Int {
    return a.z < b.z ? -1 : 1;
  }
}
