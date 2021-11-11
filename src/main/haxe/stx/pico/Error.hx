package stx.pico;

typedef ErrorDef<E> = {
  public var pos(get,null) : Option<Pos>;
  public function get_pos(): Option<Pos>;

  public var val(get,null) : Option<E>;
  public function get_val() : Option<E>;

  public var lst(get,null) : Option<Error<E>>;
  public function get_lst() : Option<Error<E>>;

  public function toError():Error<E>;

  public function cons(e:Error<E>):Error<E>;

}
interface ErrorApi<E>{
  public var pos(get,null) : Option<Pos>;
  public function get_pos(): Option<Pos>;

  public var val(get,null) : Option<E>;
  public function get_val() : Option<E>;

  public var lst(get,null) : Option<Error<E>>;
  public function get_lst() : Option<Error<E>>;

  public function toError():Error<E>;

  public function cons(e:Error<E>):Error<E>;
}
@:using(stx.pico.Error.ErrorLift)
@:forward abstract Error<E>(ErrorDef<E>) from ErrorDef<E> to ErrorDef<E>{
  static public var _(default,never) = ErrorLift;
  public function new(self) this = self;
  static public function lift<E>(self:ErrorDef<E>):Error<E> return new Error(self);

  public function prj():ErrorDef<E> return this;
  private var self(get,never):Error<E>;
  private function get_self():Error<E> return lift(this);

  @:to public function toIterable():Iterable<E>{
    return [this].concat(_.rest(this)).map_filter(x -> x.val);
  }
}
class ErrorLift{
  static public function concat<E>(self:Error<E>,that:Error<E>):Error<E>{
    return new stx.pico.error.term.ErrorConcat(self,that);
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

  static public function map<E,EE>(self:Error<E>,fn:E->EE):Error<EE>{
    return new stx.pico.error.term.ErrorMap(self,fn).toError();
  }
}
