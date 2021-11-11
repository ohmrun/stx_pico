package stx.pico.error.term;

class ErrorMap<E,EE> extends ErrorBase<EE>{
  final delegate : Error<E>;
  public function new(delegate:Error<E>,map:E->EE){
    super();
    this.delegate = delegate;
    this.map      = map;
  }
  final map : E -> EE;

  public function get_pos(): Option<Pos>{
    return delegate.pos;
  }
  public function get_val() : Option<EE>{
    return delegate.val.map(map);
  }
  public function get_lst() : Option<Error<EE>>{
    return delegate.lst.map(x -> x.map(map));
  }
  public function cons(that:Error<EE>){
    return new ErrorConcat(this,that).toError();
  }
}