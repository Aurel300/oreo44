package input;

import js.html.*;

class CameraInputMethod implements InputMethod {
  var video:VideoElement;
  var canvas:CanvasElement;
  var context:CanvasRenderingContext2D;
  var tracker:Dynamic;

  public function new() {
    var dom = js.Browser.document;
    video = cast dom.getElementById("video");
    canvas = cast dom.getElementById("debug");
    context = canvas.getContext('2d');
    untyped __js__("tracking.ColorTracker.registerColor('green', {0});", isGreen);
    untyped __js__("tracking.ColorTracker.registerColor('blue', {0});", isBlue);
    tracker = untyped __js__("new tracking.ColorTracker(['yellow', 'cyan', 'green', 'magenta', 'blue']);");
    untyped __js__("tracking.track('#video', {0}, { camera: true });", tracker);
    tracker.on('track', onTrack);
  }

  public function onTrack():Void{
    tracker.on('track', function(event) {
      context.clearRect(0, 0, canvas.width, canvas.height);
      var colours = [
        "yellow" => [],
        "magenta" => [],
        "cyan" => [],
        "green" => [],
        "blue" => []];
      event.data.forEach(function(rect:Rect) {
        colours[rect.color].push(rect);
      });
      trace(colours);
      for (group in colours) {
        if(group.length == 0){
          continue;
        }
        group.sort(compareRect);
        //trace(group[0]);
        var rect = group[0];
        context.strokeStyle = rect.color;
        context.strokeRect(rect.x, rect.y, rect.width, rect.height);
        context.font = '11px Helvetica';
        context.fillStyle = "#fff";
        context.fillText('x: ' + rect.x + 'px', rect.x + rect.width + 5, rect.y + 11);
        context.fillText('y: ' + rect.y + 'px', rect.x + rect.width + 5, rect.y + 22);
      }
    });
  }

  public function isBlue(r:Int, g:Int, b:Int): Bool {
    if (r < 50 && g < 50 && b > 200) {
      return true;
    }
    return false;
  }

  public function isGreen(r:Int, g:Int, b:Int): Bool {
    if (r < 50 && g > 200 && b < 50) {
      return true;
    }
    return false;
  }

  public function compareRect(a:Rect, b:Rect):Int {
    return (a.width * a.height < b.width * b.height ? 1 : -1);
  }

  public function tick():InputState {
    return Joystick(5, 0);
  }
}

typedef Rect = {width:Float, height:Float, color:String, x:Float, y:Float};