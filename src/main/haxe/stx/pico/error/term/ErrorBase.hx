package stx.pico.error.term;

class ErrorBase<E> extends Error<E>{
  public function new(val:Option<E>,lst:Option<Error<E>>,pos:Option<Pos>){
    super();
    this.val = val;
    this.lst = lst;
    this.pos = pos;
  }
  //@:isVar public var pos(get,null) : Option<Pos>;
  public function get_pos(){
    return pos;
  }
  //@:isVar public var lst(get,null) : Option<Error<E>>;
  public function get_lst(){
    return lst;
  }
  //@:isVar public var val(get,null) : Option<E>;
  public function get_val(){
    return val;
  }
  public function copy():Error<E>{
    final next : Array<Error<E>>  = [this.toError()].concat(this.rest());
    final done : Option<Error<E>> = next.rfold1(
      function (n:Error<E>,m:Error<E>) : Error<E> {
        final done = new ErrorBase(n.val,Some(m),n.pos);
        return done;
      }
    );
    return done.fudge();
  }
  // public function concat(that:Error<E>):Error<E>{
  //   final next : Array<Error<E>> = [this.toError()].concat(Error._.rest(this.toError()));
  //         next.push(that.copy());
  //   return next.rfold1(
  //     (n:Error<E>,m:Error<E>) -> {
  //       var res = new ErrorCls(n.val,Some(m),n.pos).toError();
  //       return res;
  //     }
  //   ).fudge();
  // }
  public function toIterable():Iterable<E>{
    return [this.toError()].concat(this.rest()).map_filter(x -> x.val);
  }
  public function concat(that:Error<E>):Error<E>{
    return new stx.pico.error.term.ErrorConcat(this,that).toError();
  }
  #if tink_core
  public function toTinkError(code=500):tink.core.Error{
    return tink.core.Error.withData(code, 'TINK_ERROR', this.val, this.pos.defv(null));
  }
  #end
}