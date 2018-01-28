package input;

enum InputState {
  Joystick(x:Float, y:Float, p:Float);
  Wheel(r:Float,y:Float, p:Float);
  Slider(i:Float);
  None;
}
