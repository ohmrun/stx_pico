package stx.pico;

typedef ErrorDef<E> = {
  public var pos(get,null) : Option<Pos>;
  public function get_pos(): Option<Pos>;

  public var val(get,null) : Option<E>;
  public function get_val() : Option<E>;

  public var lst(get,null) : Option<Error<E>>;
  public function get_lst() : Option<Error<E>>;

  public function toError():Error<E>;

  public function concat(e:Error<E>):Error<E>;
  public function copy():Error<E>;
  
  public function toString():String;
}
interface ErrorApi<E>{
  public var pos(get,null) : Option<Pos>;
  public function get_pos(): Option<Pos>;

  public var val(get,null) : Option<E>;
  public function get_val() : Option<E>;

  public var lst(get,null) : Option<Error<E>>;
  public function get_lst() : Option<Error<E>>;

  public function toError():Error<E>;

  public function concat(e:Error<E>):Error<E>;
  public function copy():Error<E>;

  public function toString():String;
}
class ErrorCls<E> implements ErrorApi<E>{
  public function new(val:Option<E>,lst:Option<Error<E>>,pos:Option<Pos>){
    this.val = val;
    this.lst = lst;
    this.pos = pos;
  }
  @:isVar public var pos(get,null) : Option<Pos>;
  public function get_pos(){
    return pos;
  }
  @:isVar public var lst(get,null) : Option<Error<E>>;
  public function get_lst(){
    return lst;
  }
  @:isVar public var val(get,null) : Option<E>;
  public function get_val(){
    return val;
  }
  public function toError():Error<E>{
    return this;
  }
  public function copy():Error<E>{
    final next : Array<Error<E>>  = [this.toError()].concat(Error._.rest(this.toError()));
    final done : Option<Error<E>> = next.rfold1(
      function (n:Error<E>,m:Error<E>) : Error<E> {
        final done = new ErrorCls(n.val,Some(m),n.pos);
        return done;
      }
    );
    return done.fudge();
  }
  public function concat(that:Error<E>):Error<E>{
    final next : Array<Error<E>> = [this.toError()].concat(Error._.rest(this.toError()));
          next.push(that.copy());
    return next.rfold1(
      (n:Error<E>,m:Error<E>) -> {
        var res = new ErrorCls(n.val,Some(m),n.pos).toError();
        return res;
      }
    ).fudge();
  }
  public function toString():String{
    return 'Error($val)';
  }
}
@:using(stx.pico.Error.ErrorLift)
@:forward abstract Error<E>(ErrorDef<E>) from ErrorDef<E> to ErrorDef<E>{
  static public var _(default,never) = ErrorLift;
  public function new(self) this = self;
  static public function lift<E>(self:ErrorDef<E>):Error<E> return new Error(self);
  static public function make<E>(data:Option<E>,lst:Option<Error<E>>,?pos:Pos){
    return lift(new ErrorCls(data,lst,Some(pos)));
  }
  public function prj():ErrorDef<E> return this;
  private var self(get,never):Error<E>;
  private function get_self():Error<E> return lift(this);

  @:to public function toIterable():Iterable<E>{
    return [this].concat(_.rest(this)).map_filter(x -> x.val);
  }
}
class ErrorLift{
  static public function concat<E>(self:Error<E>,that:Error<E>):Error<E>{
    return new stx.pico.error.term.ErrorConcat(self,that).toError();
  }
  static public function rest<E>(self:Error<E>):Array<Error<E>>{
    var arr = [];
    while(true){
      switch(self.lst){
        case Some(ok) : 
          arr.unshift(ok);
          arr  = arr.concat(ok.rest());
          self = ok;
        case None : break;
      }
    }
    return arr;
  }
  static public function content<E>(self:Error<E>):Array<E>{
    return self.val.map(x -> self.rest().map_filter(err -> err.val).snoc(x)).def(() -> self.rest().map_filter((x) -> x.val));
  }
  #if tink_core
  static public function toTinkError<E>(self:Error<E>,code=500):tink.core.Error{
    return tink.core.Error.withData(code, 'TINK_ERROR', self.val, self.pos.defv(null));
  }
  #end
  static public function map<E,EE>(self:Error<E>,fn:E->EE):Error<EE>{
    return new stx.pico.error.term.ErrorMap(self,fn).toError();
  }
}
