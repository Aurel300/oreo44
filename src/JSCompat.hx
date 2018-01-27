import js.html.Event;
import js.html.EventTarget;

class JSCompat {
  public static inline function addEventListener<T:Event>(
    target:EventTarget, event:String, handler:T->Void
  ):Void {
    target.addEventListener(event, handler);
  }
}
