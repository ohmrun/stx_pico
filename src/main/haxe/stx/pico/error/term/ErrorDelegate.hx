package stx.pico.error.term;

class ErrorDelegate<E> extends ErrorBase<E>{
  final delegate : Error<E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  public function get_pos(): Option<Pos>{
    return delegate.pos;
  }
  public function get_val() : Option<E>{
    return delegate.val;
  }
  public function get_lst() : Option<Error<E>>{
    return delegate.lst;
  }
  public function cons(that:Error<E>){
    return delegate.cons(that);
  }
}