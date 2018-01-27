package input;

enum InputState {
  Joystick(x:Float, y:Float);
  Wheel(a:Float);
  Slider(i:Float);
  None;
}
