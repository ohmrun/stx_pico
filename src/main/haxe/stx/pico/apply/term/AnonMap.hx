package stx.pico.apply.term;

class AnonMap<P,R,Ri> extends Map<P,R,Ri>{
  
  public function new(delegate,_map){
    super(delegate);
    this._map = _map;
  }
  public final _map : R -> Ri;
  
  public inline function map(p:R):Ri{
    return _map(p);
  } 
}