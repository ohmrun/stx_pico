package stx.pico;

typedef ErrorDef<E> = Iterable<E> & ExceptionDef & {
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
  public function toIterable():Iterable<Null<E>>;

  public function raise():Void;
}
interface ErrorApi<E> extends ExceptionApi{
  public var pos(get,null) : Option<Pos>;
  public function get_pos(): Option<Pos>;

  public var val(get,null) : Option<E>;
  public function get_val() : Option<E>;

  public var lst(get,null) : Option<Error<E>>;
  public function get_lst() : Option<Error<E>>;

  public var exception(get,null) : Exception;
  public function get_exception() : Exception;
  
  public function toError():Error<E>;

  public function concat(e:Error<E>):Error<E>;
  public function copy():Error<E>;

  public function toString():String;
  public function toIterable():Iterable<Null<E>>;

  public function raise():Void;
}
abstract class Error<E> implements ErrorApi<E>{
  @:noUsing static public inline function make<E>(data:Option<E>,?lst:Option<Error<E>>,?pos:Pos):Error<E>{
    if(data == null){ data = None; }
    if(lst == null){ lst = None; }
    return new ErrorBase(data,lst,pos == null ? None : Some(pos)).toError();
  }
  static public function iterable<E>(self:Error<E>):Iterable<Error<E>>{
    return {
      iterator : () -> {
        hasNext : () -> self != null,
        next    : () -> {
          final val   = self;
          self        = self.lst.defv(null);
          return val;
        }
      }
    };
  }
  private function new(?exception:Exception){
    this.exception = exception == null ? new Exception('STX_ERROR') : exception;
  }
  
  public var pos(get,null) : Option<Pos>;
  abstract public function get_pos(): Option<Pos>;

  public var val(get,null) : Option<E>;
  abstract public function get_val() : Option<E>;

  public var lst(get,null) : Option<Error<E>>;
  abstract public function get_lst() : Option<Error<E>>;

  abstract public function concat(e:Error<E>):Error<E>;
  abstract public function copy():Error<E>;
  abstract public function iterator():Iterator<Null<E>>;
  abstract public function toIterable():Iterable<Null<E>>;
  
  public function errate<EE>(fn:E->EE):Error<EE>{
    return Error.make(
      this.val.map(fn),
      this.lst.map(x -> x.errate(fn)),
      this.pos.defv(null)
    ).toError();
  }
  public function toError():Error<E>{
    return this;
  }
  public function toString():String{
    return 'Error($val) at $pos\n${exception.stack}';
  }
  public function get_stack():CallStack{
    return this.exception.stack;
  }
} 
class ErrorBase<E> extends Error<E>{
  public function new(val:Option<E>,lst:Option<Error<E>>,pos:Option<Pos>){
    super();
    this.val = val;
    this.lst = lst;
    this.pos = pos;
  }
  public function get_pos(){
    return pos;
  }
  public function get_lst(){
    return lst;
  }
  public function get_val(){
    return val;
  }
  private static function rebuild<E>(arr:Array<Error<E>>):Error<E>{
    var head = arr.head();
    var tail = arr.tail();
    return switch([head,tail.is_defined()]){
      case [Some(h),true]   : Error.make(h.val,rebuild(tail),h.pos.defv(null));
      case [Some(h),false]  : Error.make(h.val,None,h.pos.defv(null));
      case [None,_]         : Error.make(None,None,null);
    }
  }
  public function copy():Error<E>{
    var nxt = Lambda.array(Error.iterable(this));
        nxt.reverse();
    return rebuild(nxt);
  }
  public function concat(that:Error<E>):Error<E>{
    var lhs = Error.iterable(this);
    var rhs = Error.iterable(this);
    var nxt = Lambda.array(lhs.concat(rhs));
        nxt.reverse();
    return rebuild(nxt);
  }
  public function iterator():Iterator<Null<E>>{
    var self : Error<E> = this;
    return {
      hasNext : () -> self != null,
      next    : () -> {
        final val   = self.val.defv(null);
        self        = self.lst.defv(null);
        return val;
      }
    }
  }
  public function toIterable():Iterable<Null<E>>{
    return {
      iterator : this.iterator
    }
  }
  public function get_exception(){
    return this.exception;
  }
  public function details(){
    return this.exception.details();
  }
  #if tink_core
  public function toTinkError(code=500):tink.core.Error{
    return tink.core.Error.withData(code, 'TINK_ERROR', this.val, this.pos.defv(null));
  }
  #end
  public function raise(){
    throw exception;
  }
}