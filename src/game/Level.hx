package game;

class Level {
  public var game:Game;
  public var state:LevelState;
  public var waves:Array<Wave> = [];
  public var stateTime:Int;
  
  public function new(game:Game) {
    this.game = game;
    updateState(Vertical);
  }
  
  function updateState(state:LevelState) {
    this.state = state;
    stateTime = 0;
    game.render.mode(state);
  }
  
  public function tick() {
    if (Math.random() < 0.01) waves.push(new Wave());
    waves = [ for (w in waves) {
        w.tick();
        if (w.remove) continue;
        w;
      } ];
    stateTime++;
    if (stateTime >= 60) {
      updateState(switch (state) {
          case Vertical: Plane;
          case Horizontal: Vertical;
          case Plane: Horizontal;
        });
    }
  }
}

class Wave {
  public var entities:Array<Entity> = [];
  public var type:WaveType;
  public var remove:Bool = false;
  public var time:Int;
  
  public function new() {
    entities = [ for (i in 0...5) {
        var e = new Enemy();
        Main.game.addEntity(e);
        e;
      } ];
    type = Horizontal;
    time = 0;
  }
  
  public function tick():Void {
    var oob = true;
    var alive = false;
    for (i in 0...entities.length) {
      var e = entities[i];
      if (!e.remove) alive = true;
      switch (type) {
        case Horizontal:
        e.x = time - i * 20;
        e.y = 20;
        if (e.x < 600) oob = false;
        else e.remove = true;
      }
    }
    if (oob || !alive) remove = true;
    time++;
  }
}

enum WaveType {
  Horizontal;
}
