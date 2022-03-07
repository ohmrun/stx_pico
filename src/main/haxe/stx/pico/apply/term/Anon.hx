package stx.pico.apply.term;

class Anon<P,R> extends ApplyCls<P,R>{
  public function new(_apply){
    this._apply = _apply;
  }
  public final _apply : P -> R;
  
  public inline function apply(p:P):R{
    return _apply(p);
  } 
}