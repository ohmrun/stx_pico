package stx.pico;

import stx.pico.reduct.term.Anon;

typedef Thunk<T> = Void -> T;

@:forward abstract Reduct<P,R,X>(ReductDef<P,R,X>) from ReductDef<P,R,X> to ReductDef<P,R,X>{
  static public inline function _() return Constructor.ZERO;

  public function new(self) this = self;
  static public function make<P,R,X>(step:P->X->X,unit:Void -> X,pure:X->R):Reduct<P,R,X> return _().make(step,unit,pure);
}

private class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public function make<P,R,X>(step:P->X->X,unit:Void -> X,pure:X->R):Reduct<P,R,X>{
    return {
      step : step,
      unit : unit,
      pure : pure
    };
  }
}
private class Destructure extends Clazz{

}
class IterableReduct{
  public function reduct<P,R,X>(fold:Reduct<P,R,X>,i:Iterable<P>):R{
    return fold.pure(i.fold(
      fold.step,
      fold.unit()
    ));
  }
}
class Sum implements ReductApi<Int,Int,Int>{
  public function new(){}
  public function unit(){
    return 0;
  }
  public function step(p:Int,r:Int):Int{
    return p + r;
  }
  public function pure(x:Int):Int{
    return x;
  }
  public function asReductDef(){
    return this;
  }
}
class Mult implements ReductApi<Int,Int,Int>{
  public function new(){}
  public function unit(){
    return 0;
  }
  public function step(p:Int,r:Int):Int{
    return p * r;
  }
  public function pure(x:Int):Int{
    return x;
  }
  public function asReductDef(){
    return this;
  }
}