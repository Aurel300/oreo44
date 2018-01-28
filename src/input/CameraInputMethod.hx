package input;

import js.html.*;
import haxe.ds.Vector;
import hxmath.math.MathUtil;
import hxmath.math.Vector2;
import hxmath.math.Vector3;

class CameraInputMethod implements InputMethod {
  inline static var JOY_MAIN = "orange";
  inline static var JOY_SECOND = "magenta";
  inline static var WHEEL_MAIN = "magenta";
  inline static var WHEEL_SECOND = "orange";
  inline static var CACHE_SIZE = 1;
  inline static var ROTATION_MULT = 3;
  static var SCREEN_CENTER = new Vector2(200,112);
  public static var lastState:InputState = None;
  var video:VideoElement;
  var canvas:CanvasElement;
  var context:CanvasRenderingContext2D;
  var tracker:Dynamic;
  var currentTick:Int = 0;


  public function new() {
    var dom = js.Browser.document;
    video = cast dom.getElementById("video");
    canvas = cast dom.getElementById("debug");
    context = canvas.getContext('2d');
    //untyped __js__("tracking.ColorTracker.registerColor('turquoise', {0});", isTurquoise);
    //untyped __js__("tracking.ColorTracker.registerColor('orange', {0});", isOrange);
    tracker = untyped __js__("new tracking.ColorTracker(['orange', 'magenta']);");
    untyped __js__("tracking.track('#video', {0}, { camera: true });", tracker);
    tracker.on('track', onTrack);
    tracker.setMinGroupSize(15);
    tracker.setMinDimension(15);
    lastState = InputState.None;
  }

  public function onTrack(event):Void {
    context.clearRect(0, 0, canvas.width, canvas.height);
    var colours = [
      "cyan" => [],
      "magenta" => [],
      "turquoise" => [],
      "orange" => []
    ];
    for(rect in (event.data:Array<Rect>)){
      colours[rect.color].push(rect);
      drawRect(rect);
    }
    var method = decideState(colours);
    //lastStates[currentTick++ % CACHE_SIZE] = method;
    lastState = method;
    //method = recentAverageState();
    debugInput(method);
  }

  /*public function recentAverageState():InputState {
    var jcount = 0, wcount = 0, scount = 0, ncount = 0;
    var jx = 0.0, jy = 0.0, jz = 0.0, wx = 0.0, wy = 0.0, wz = 0.0;
    var sa = 0.0;
    for (state in lastStates) {
      switch (state) {
        case Joystick(x, y, z):
          jcount++;
          jx += x;
          jy += y;
          jz += z;
        case Wheel(x, y, z): 
          wcount++;
          wx += x;
          wy += y;
          wz += z;
        case Slider(x):
          scount++;
          sa += x;
        case None:
          ncount++;
      }
    }
    return if(jcount >= wcount && jcount >= scount && jcount >= ncount)
        Joystick(jx / jcount, jy / jcount, jz / jcount);
    else if(wcount >= scount && wcount >= ncount)
        Wheel(wx / wcount, wy / wcount, wz / wcount);
    else if(scount >= ncount)
        Slider(sa / scount);
    else
        None;
  }*/

  public function decideState(groups:Map<String,Array<Rect>>): InputState {
    var center:Vector2;
    var proxy:Vector2;
    var proxy2:Vector2;
    var proxy3:Vector2;
    if(groups[JOY_SECOND].length == 3 && groups[JOY_MAIN].length == 1) {
      center = centroid(groups[JOY_MAIN][0]);
      proxy = centroid(groups[JOY_SECOND][0]);
      proxy2 = centroid(groups[JOY_SECOND][1]);
      proxy3 = centroid(groups[JOY_SECOND][2]);
      var rotations = controllerRotation(center, proxy, proxy2, proxy3);
      return Joystick(rotations.y * 2, -rotations.z * 2, rotations.x);
    }
    if(groups[WHEEL_MAIN].length == 1 && groups[WHEEL_SECOND].length == 3) {
      center = centroid(groups[WHEEL_MAIN][0]);
      proxy = centroid(groups[WHEEL_SECOND][0]);
      proxy2 = centroid(groups[WHEEL_SECOND][1]);
      proxy3 = centroid(groups[WHEEL_SECOND][2]);
      var rotations = controllerRotation(center, proxy, proxy2, proxy3);
      return Wheel(rotations.x, rotations.y, rotations.z);
    }
    return None;
  }

  public function controllerRotation(center:Vector2, proxy:Vector2, proxy2:Vector2, proxy3:Vector2):Vector3 {
    var v1 = proxy - center;
    var v2 = proxy2 - center;
    var v3 = proxy3 - center;
    if(MathUtil.det2x2(v1.x, v2.x, v1.y, v2.y) < 0) {
      Swap.swap(v1, v2);
      Swap.swap(proxy, proxy2);
    }
    if(MathUtil.det2x2(v2.x, v3.x, v2.y, v3.y) < 0) {
      Swap.swap(v3, v2);
      Swap.swap(proxy3, proxy2);
    }
    if(MathUtil.det2x2(v1.x, v2.x, v1.y, v2.y) < 0) {
      Swap.swap(v1, v2);
      Swap.swap(proxy, proxy2);
    }
//    drawVector(center, center + v1, 'turquoise');
//    drawVector(center, center + v2, 'red');
//    drawVector(center, center + v3, 'blue');
    var oppositeV1 = proxy2 - proxy3;
    var oppositeV3 = proxy2 - proxy;

    var d1 = v1.lengthSq;
    var d3 = v3.lengthSq;
    var od1 = oppositeV1.lengthSq;
    var od3 = oppositeV3.lengthSq;
    return new Vector3(
      v3.signedAngleWith(new Vector2(-1, 0)) * 5,
      Math.acos(Math.min(d1, od1) / Math.max(d1, od1)) * (d1 > od1 ? -1 : 1), 
      Math.acos(Math.min(d3, od3) / Math.max(d3, od3)) * (d3 > od3 ? -1 : 1));
  }

  public function debugInput(input:InputState):Void {
    var mode = "None";
    switch(input){
      case Wheel(r, y, p):
        mode = "wheel";
        drawVector(SCREEN_CENTER, SCREEN_CENTER + Vector2.fromPolar(r, 300), 'red');
        drawVector(SCREEN_CENTER, SCREEN_CENTER + Vector2.fromPolar(y, 300), 'turquoise');
        drawVector(SCREEN_CENTER, SCREEN_CENTER + Vector2.fromPolar(p, 300), 'blue');
      case Joystick(r, y, p):
        mode = "joystick";
        drawVector(SCREEN_CENTER, SCREEN_CENTER + Vector2.fromPolar(r, 300), 'red');
        drawVector(SCREEN_CENTER, SCREEN_CENTER + Vector2.fromPolar(y, 300), 'turquoise');
        drawVector(SCREEN_CENTER, SCREEN_CENTER + Vector2.fromPolar(p, 300), 'blue');
      default:
    }
    context.font = '11px Helvetica';
    context.fillStyle = "#333";
    context.fillText('mode: $mode', 20, 20);
  }

  public function drawVector(from:Vector2, to:Vector2, color:String):Void {
    context.strokeStyle = color;
    context.beginPath();
    context.moveTo(from.x, from.y);
    context.lineTo(to.x, to.y);
    context.stroke();
  }

  public function drawRect(rect:Rect) {
    context.strokeStyle = rect.color;
    context.strokeRect(rect.x, rect.y, rect.width, rect.height);
  }

  public function isBlue(r:Int, g:Int, b:Int): Bool {
    if (r < 50 && g < 50 && b > 200) {
      return true;
    }
    return false;
  }

  public function isTurquoise(r:Int, g:Int, b:Int): Bool {
    var total = r + g + b;
    if(total > 280 || total < 180){
      return false;
    }
    var ratioB = (100 / 235) / (b / total);
    var ratioG = (116 / 235) / (g / total);
    return ratioB > 0.75 && ratioB < 1.25 &&
          ratioG > 0.75 && ratioG < 1.25;
  }

  public function isOrange(r:Int, g:Int, b:Int): Bool {
    var threshold = 70;
    var dx = r - 255;
    var dy = g - 130;
    var dz = b - 0;

    if ((r - g) >= threshold && (r - b) >= threshold * 2) {
      return true;
    }
    return dx * dx + dy * dy + dz * dz < 30000;
  }

  public function centroid(rect:Rect):Vector2 {
    return new Vector2(rect.x + rect.width / 2, rect.y + rect.height / 2);
  } 

  public function compareRect(a:Rect, b:Rect):Int {
    return (a.width * a.height < b.width * b.height ? 1 : -1);
  }

  public function tick():InputState {
    return lastState;
  }
}

typedef Rect = {width:Float, height:Float, color:String, x:Float, y:Float};