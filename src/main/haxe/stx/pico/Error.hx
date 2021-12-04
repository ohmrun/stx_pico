package stx.pico;

typedef ErrorDef<E> = ExceptionDef & {
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
interface ErrorApi<E> extends ExceptionApi{
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
abstract class Error<E> implements ErrorApi<E> extends Exception{
  static public function make<E>(data:Option<E>,lst:Option<Error<E>>,?pos:Pos){
    return new stx.pico.error.term.ErrorBase(data,lst,Some(pos));
  }
  public function new(?previous:Exception, ?native:Any){
    super('STX_ERROR',previous,native);
  }
  public var pos(get,null) : Option<Pos>;
  abstract public function get_pos(): Option<Pos>;

  public var val(get,null) : Option<E>;
  abstract public function get_val() : Option<E>;

  public var lst(get,null) : Option<Error<E>>;
  abstract public function get_lst() : Option<Error<E>>;


  abstract public function concat(e:Error<E>):Error<E>;
  abstract public function copy():Error<E>;
  //abstract public function content():Array<E>;
  public function rest():Array<Error<E>>{
    var arr   = [];
    var self  = this;
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
  public function content():Array<E>{
    return this.val.map(x -> this.rest().map_filter(err -> err.val).snoc(x)).def(() -> this.rest().map_filter((x) -> x.val));
  }
  public function errate<EE>(fn:E->EE):Error<EE>{
    return new stx.pico.error.term.ErrorMap(this,fn).toError();
  }

  public function toError():Error<E>{
    return this;
  }
  override public function toString():String{
    return 'Error($val)';
  }
} 