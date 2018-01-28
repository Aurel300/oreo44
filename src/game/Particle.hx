package game;

class Particle extends Entity {
  public var ptype:ParticleType;
  public var vx:Float;
  public var vy:Float;
  public var age:Int;
  
  public function new(ptype:ParticleType, x:Float, y:Float) {
    super(Particle);
    this.ptype = ptype;
    age = 0;
    switch (ptype) {
      case Thruster:
      this.x = x + Math.random() * 20 - 10;
      this.y = y + 10;
      vx = Math.random() - .5;
      vy = 5 + Math.random() * 2;
      case Explosion:
      var a = Math.random() * Math.PI * 2;
      var c = Math.cos(a);
      var s = Math.sin(a);
      this.x = x + c * 10;
      this.y = y + s * 10;
      vx = Math.random() * c;
      vy = Math.random() * s;
      case Spark:
      this.x = x + Math.random() * 20 - 10;
      this.y = y + Math.random() * 20 - 10;
      vx = Math.random() * 3 - 1.5;
      vy = -3 + Math.random() * 2;
    }
    sprite = game.render.createSprite("particle " + (switch (ptype) {
        case Thruster: "thruster";
        case Explosion: "explosion";
        case Spark: "spark";
      }));
  }
  
  override public function tick():Void {
    age++;
    switch (ptype) {
      case Spark:
      vy += 0.2;
      case _:
    }
    x += vx;
    y += vy;
    if (y < -Game.LETTER || y > Game.SCREEN + Game.LETTER) remove = true;
    else if (age >= 40 + Math.random() * 10) remove = true;
    super.tick();
  }
}

enum ParticleType {
  Thruster;
  Explosion;
  Spark;
}
