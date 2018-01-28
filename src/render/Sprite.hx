package render;

class Sprite {
  public var type:String;
  public var id:Int;
  
  public var x(get, set):Float;
  function get_x():Float {
    return 0;
  }
  function set_x(x:Float):Float {
    return 0;
  }
  
  public var y(get, set):Float;
  function get_y():Float {
    return 0;
  }
  function set_y(y:Float):Float {
    return 0;
  }
  
  public var hurting(never, set):Bool;
  function set_hurting(h:Bool):Bool {
    return h;
  }
  
  public function new(type:String, id:Int) {
    this.type = type;
    this.id = id;
  }
}
