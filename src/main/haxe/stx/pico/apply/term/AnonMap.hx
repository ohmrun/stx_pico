package stx.pico.apply.term;


/**
 * Lambda implementation of `Class` oriented `map` function for runtime composition.
 */
class AnonMap<P,R,Ri> extends Map<P,R,Ri>{
  
  public function new(delegate,_map){
    super(delegate);
    this._map = _map;
  }
  /**
   * underlying implementation.
   */
  public final _map : R -> Ri;
  
  /**
   * defers to `_map`
   * @param p 
   * @return Ri
   */
  public inline function map(p:R):Ri{
    return _map(p);
  } 
}