package stx.pico.error.term;

class ErrorConcat<E> extends ErrorDelegate<E>{
  final other : Error<E>;
  public function new(delegate,other){
    super(delegate);
    this.other = other;
  }
  override public function get_lst(){
    return delegate.lst.fold(
      ok -> Some(new ErrorConcat(ok,other).toError()),
      () -> Some(other)
    );
  }
}