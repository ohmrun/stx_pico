package stx.pico.error.term;

abstract class ErrorAnon<E> implements ErrorApi<E>{
  public function new(get_pos,get_val,get_lst){
    this.get_pos = get_pos;
    this.get_val = get_val;
    this.get_lst = get_lst;
  }
  public var pos(get,null) : Option<Pos>;
  dynamic public function get_pos(): Option<Pos>;

  public var val(get,null) : Option<E>;
  dynamic public function get_val() : Option<E>;

  public var lst(get,null) : Option<Error<E>>;
  dynamic public function get_lst() : Option<Error<E>>;

  public function toError():Error<E>{
    return Error.lift(this);
  }

  abstract public function cons(e:Error<E>):Error<E>;
}