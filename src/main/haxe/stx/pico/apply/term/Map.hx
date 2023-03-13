package stx.pico.apply.term;

/**
 * Abstract implementation of `Class` oriented `map` function for use with code writing macros. 
 */
abstract class Map<P,R,Ri> extends Delegate<Apply<P,R>,P,Ri>{

  /**
   * Function to apply to the return value of `Apply`
   * @param p 
   * @return Ri
   */
  abstract public function map(p:R):Ri;
  
  public inline function apply(p:P):Ri{
    return map(delegate.apply(p));
  } 
}