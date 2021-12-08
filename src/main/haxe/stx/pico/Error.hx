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
  public function toIterable():Iterable<Null<E>>;
}
abstract class Error<E> implements ErrorApi<E> extends Exception{
  @:noUsing static public function make<E>(data:Option<E>,lst:Option<Error<E>>,?pos:Pos):Error<E>{
    if(data == null){ data = None; }
    if(lst == null){ lst = None; }
    return new ErrorBase(data,lst,pos == null ? None : Some(pos)).toError();
  }
  // @:noUsing static public function iter<E>(data:Iterable<E>,?pos:Pos):Error<E>{
  //   var all = Lambda.array(data);
  //       all.reverse();
    
  //   function rec(arr:Array<E>):Error<E>{
  //     var head = arr.head();
  //     var tail = arr.tail();
  //     trace(head);
  //     trace(tail);
  //     return switch([head,tail.is_defined()]){
  //       case [Some(h),true]   : Error.make(Some(h),Some(rec(tail)),pos);
  //       case [Some(h),false]  : Error.make(Some(h),None,pos);
  //       case [None,_]         : Error.make(None,None,pos);
  //     }
  //   }
  //   var result = rec(all);
  //   return result;
  // }
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
  private function new(?previous:Exception, ?native:Any){
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
  override public function toString():String{
    return 'Error($val) at $pos\n${stack}';
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
  #if tink_core
  public function toTinkError(code=500):tink.core.Error{
    return tink.core.Error.withData(code, 'TINK_ERROR', this.val, this.pos.defv(null));
  }
  #end
}