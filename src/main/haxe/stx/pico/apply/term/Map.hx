package stx.pico.apply.term;

abstract class Map<P,R,Ri> extends Delegate<Apply<P,R>,P,Ri>{
  
  abstract public function map(p:R):Ri;
  
  public inline function apply(p:P):Ri{
    return map(delegate.apply(p));
  } 
}