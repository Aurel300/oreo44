package game;

class Level {
  public var game:Game;
  public var state:LevelState;
  public var stateTime:Int;
  public var transitionLength:Int = 20;
  public var stateQueuePos:Int;
  public var stateQueue:Array<LevelState> = [Vertical, Horizontal, Plane, Horizontal];
  public var stateLength:Array<Int> = [90000, 30, 30, 30];
  
  public var waves:Array<Wave> = [];
  
  public function new(game:Game) {
    this.game = game;
    stateQueuePos = stateQueue.length - 1;
    nextState();
    //waves.push(new Wave());
  }
  
  function nextState():Void {
    stateTime = 0;
    stateQueuePos++;
    stateQueuePos %= stateQueue.length;
    if (this.state == null) {
      updateState(stateQueue[stateQueuePos]);
    } else {
      updateState(Transition(this.state, stateQueue[stateQueuePos]));
    }
  }
  
  function updateState(state:LevelState):Void {
    this.state = state;
    stateTime = 0;
    game.render.mode(state);
  }
  
  public function tick() {
    waves = [ for (w in waves) {
        w.tick();
        if (w.remove) continue;
        w;
      } ];
    stateTime++;
    switch (state) {
      case Transition(_, to):
      if (stateTime >= transitionLength) updateState(to);
      return;
      case Vertical:
      if (Math.random() < 0.01) waves.push(new Wave());
      case Horizontal:
      if (Math.random() < 0.01) game.addEntity(new Feature(Math.random() < .5, Math.random()));
      case _:
    }
    if (stateTime >= stateLength[stateQueuePos]) nextState();
  }
}

class Wave {
  public var entities:Array<Entity> = [];
  public var type:WaveType;
  public var remove:Bool = false;
  public var time:Int;
  
  public function new() {
    var left = true;
    entities = [ for (i in 0...15) {
        var e = new Enemy();
        Main.game.addEntity(e);
        e;
      } ];
    type = Snake(left);
    time = 0;
    tick();
  }
  
  public function tick():Void {
    var oob = true;
    var alive = false;
    for (i in 0...entities.length) {
      var e = entities[i];
      var etime:Int = time - i * 15;
      if (!e.remove) alive = true;
      var tx = 0.0;
      var ty = 0.0;
      switch (type) {
        case Horizontal(left):
        tx = Game.SCREEN_LETTER_HALF
          + (-Game.SCREEN_LETTER_HALF + etime) * (left ? 1 : -1);
        ty = 50;
        case HorizontalRipple(left, n):
        var xc = (-Game.SCREEN_LETTER_HALF + etime);
        tx = Game.SCREEN_LETTER_HALF
          + xc * (left ? 1 : -1);
        var s = Math.sin((xc / Game.SCREEN_LETTER) * Math.PI * n);
        ty = 50 + s * s * 150;
        case Surround(left):
        var xc = lerpArr([-1.1, .8, .8, -.8, -.8, 1, 2], etime / 100);
        var yc = lerpArr([.7, .7, .2, .2, .7, .7, .7], etime / 100);
        tx = Game.SCREEN_LETTER_HALF + xc * Game.SCREEN_LETTER_HALF * (left ? 1 : -1);
        ty = yc * Game.SCREEN;
        case Snake(left):
        var xc = lerpArr([-1.1, .8, -.8, 1, 2], etime / 100);
        var yc = lerpArr([.2, .2, .7, .7, .7], etime / 100);
        tx = Game.SCREEN_LETTER_HALF + xc * Game.SCREEN_LETTER_HALF * (left ? 1 : -1);
        ty = yc * Game.SCREEN;
      }
      if (etime < 0) {
        e.x = e.y = -20;
      } else if (etime == 0) {
        e.x = tx;
        e.y = ty;
      } else {
        e.x = (e.x * 7 + tx) / 8;
        e.y = (e.y * 7 + ty) / 8;
      }
      if (e.x > -Game.LETTER && e.x < Game.SCREEN_LETTER + Game.LETTER
          && e.y > -Game.LETTER && e.y < Game.SCREEN + Game.LETTER) oob = false;
      else e.remove = true;
    }
    //trace([ for (e in entities) '${e.x} ${e.y}' ]);
    if (oob || !alive) remove = true;
    time++;
  }
  
  function lerpArr(a:Array<Float>, t:Float):Float {
    if (t < 0) return 0;
    var p1 = Math.floor(t);
    return lerp(a[p1 % a.length], a[(p1 + 1) % a.length], t - p1);
  }
  
  function lerp(a:Float, b:Float, r:Float):Float {
    return a * (1 - r) + b * r;
  }
}

enum WaveType {
  Horizontal(left:Bool);
  HorizontalRipple(left:Bool, n:Int);
  Surround(left:Bool);
  Snake(left:Bool);
}
