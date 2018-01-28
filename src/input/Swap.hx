package input;
#if macro
import haxe.macro.Expr;
#end
class Swap {
  public static macro function swap(a:Expr, b:Expr):Expr {
    return macro {
      var temp = $a;
      $a = $b;
      $b = temp;
    }
  }
}
