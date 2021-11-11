package stx.pico.error.term;

abstract class ErrorBase<E>{
  public function new(){}
  public var pos(get,null) : Option<Pos>;
  abstract public function get_pos(): Option<Pos>;

  public var val(get,null) : Option<E>;
  abstract public function get_val() : Option<E>;

  public var lst(get,null) : Option<Error<E>>;
  abstract public function get_lst() : Option<Error<E>>;


  abstract public function cons(e:Error<E>):Error<E>;
  
  public function toError():Error<E>{
    return Error.lift(this);
  }
} 