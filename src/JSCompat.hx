import js.html.*;

class JSCompat {
  public static inline function addEventListener<T:Event>(
    target:EventTarget, event:String, handler:T->Void
  ):Void {
    target.addEventListener(event, handler);
  }
  
  public static inline function element(id:String):Element {
    return js.Browser.document.getElementById(id);
  }
  
  public static inline function create(cls:String):Element {
    var ret = js.Browser.document.createElement("div");
    ret.className = cls;
    return ret;
  }
}
