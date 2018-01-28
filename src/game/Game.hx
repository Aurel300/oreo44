package game;

import js.*;
import input.*;
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
  public var hp:Float = 0.0;
  public var playing:Bool = false;
  public var bgPhase:Int = 0;
  public var gameOvered:Bool = false;
  
  public function new(input:InputMethod, render:Renderer) {
    Main.game = this;
    this.input = input;
    this.render = render;
    Browser.window.requestAnimationFrame(tick);
    entities = [];
    entityTypes = [
         Player => []
        ,Bullet(false) => []
        ,Bullet(true) => []
        ,Enemy => []
        ,Pickup => []
        ,Feature => []
        ,Particle => []
        ,BG => []
      ];
    //restart();
  }
  
  public function cleanup():Void {
    entities = [ for (e in entities) {
        if (e.type != BG && e.type != Particle) {
          e.destroy();
          continue;
        }
        e;
      } ];
    entityTypes = [
         Player => []
        ,Bullet(false) => []
        ,Bullet(true) => []
        ,Enemy => []
        ,Pickup => []
        ,Feature => []
        ,Particle => entityTypes[EntityType.Particle]
        ,BG => entityTypes[EntityType.BG]
      ];
    hp = 1.0;
    playing = false;
  }
  
  public function restart():Void {
    cleanup();
    pauseFrames = 0;
    addEntity(player = new Player());
    level = new Level(this);
    cooldown = 0;
    playing = true;
  }
  
  public function addEntity(e:Entity):Void {
    entities.push(e);
    entityTypes[e.type].push(e);
  }
  
  function tick(e):Void {
    if (KeyboardInputMethod.state["Space"] && !playing) {
      restart();
    }
    Browser.window.requestAnimationFrame(tick);
    if (pauseFrames > 0) {
      pauseFrames--;
      return;
    }
    if (bgPhase > 0) bgPhase--;
    if (bgPhase == 0) {
      var n = 1 + Math.floor(Math.random() * 3);
      for (i in 0...n) addEntity(new BG());
      bgPhase += 90 + Math.floor(n * 20 * Math.random());
    }
    render.playing(playing, gameOvered);
    entities = [ for (e in entities) {
        if (e.type == BG || e.type == Particle) {
          e.tick();
          if (e.remove) {
            entityTypes[e.type].remove(e);
            e.destroy();
            continue;
          }
        }
        e;
      } ];
    if (!playing) {
      render.mode(LevelState.Vertical);
      render.health(1);
      return;
    }
    if (hp < 0) {
      for (i in 0...40) {
        addEntity(new Particle(Explosion, player.x + Math.random() * 10 - 5, player.y + Math.random() * 10 - 5));
      }
      // snd death
      cleanup();
      gameOvered = true;
      return;
    }
    hp = (hp < 0 ? 0 : (hp > 1 ? 1 : hp));
    render.health(hp);
    state = input.tick();
    level.tick();
    switch (level.state) {
      case Vertical:
      state = (switch (state) {
          case Joystick(x, y): Joystick(x, y);
          case _: None;
        });
      case Horizontal:
      state = (switch (state) {
          case Wheel(a): Wheel(a);
          case _: None;
        });
      case _:
    }
    if (cooldown > 0) cooldown--;
    if (cooldown % 3 == 0) {
      addEntity(new Particle(Thruster, player.x, player.y));
    }
    switch (level.state) {
      case Vertical:
      if (cooldown == 0) {
        // snd pew
        addEntity(new Bullet(true, player.x, player.y));
      }
      case _:
    }
    if (cooldown == 0) cooldown = 6;
    for (b in entityTypes[EntityType.Bullet(true)]) {
      for (e in entityTypes[EntityType.Enemy]) {
        if (collision(b, e, 15, 15)) {
          b.remove = true;
          (cast e:Enemy).hurt();
          // snd hit
        }
      }
    }
    for (b in entityTypes[EntityType.Bullet(false)]) {
      if (collision(b, player, 15, 15) && player.hurting == 0) {
        // snd hurt
        hp -= .2;
        player.hurt();
        b.remove = true;
      }
    }
    for (b in entityTypes[EntityType.Pickup]) {
      if (collision(b, player, 25, 25)) {
        // snd pickup
        hp += .4;
        player.hurt();
        b.remove = true;
      }
    }
    for (b in entityTypes[EntityType.Feature]) {
      var dy = b.y - player.y;
      dy = (dy < 0 ? -dy : dy);
      if (dy < 20) {
        var f = (cast b:Feature);
        if (f.up == (player.x < f.x) && player.hurting == 0) {
          // snd hurt
          hp -= .2;
          player.hurt();
          b.remove = true;
        }
      }
    }
    entities = [ for (e in entities) {
        if (e.type != BG && e.type != Particle) {
          e.tick();
          if (e.remove) {
            entityTypes[e.type].remove(e);
            e.destroy();
            continue;
          }
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
