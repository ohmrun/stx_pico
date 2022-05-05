package stx;

import haxe.CallStack;
import haxe.Exception;

class Pico{
  
}
interface StxMemberApi{
  public var stx_tag(get,null) : Int;
  public function get_stx_tag() : Int;
}
abstract class StxMemberCls extends Clazz{
  public var stx_tag(get,null) : Int;
  abstract public function get_stx_tag() : Int;
}
//@back2dos haxetink
@:pure typedef PosDef = 
  #if macro
    haxe.macro.Expr.Position;
  #else
    haxe.PosInfos;
  #end
typedef Pos                     = PosDef;
class PosLift{
  static public function toString(pos:Pos){
    if (pos == null) return '<no_pos>';
    #if !macro
      var f   = pos.fileName;
      var cls = pos.className;
      var fn  = pos.methodName;
      var ln  = pos.lineNumber;
      return '$f:$ln';
    #else
      return '$pos';
    #end
  }
}
typedef StdArray<T>             = std.Array<T>;
typedef StdString               = std.String;
typedef StdInt                  = Int;
typedef StdFloat                = Float;
typedef StdBool                 = Bool;
typedef StdDate                 = Date;
typedef StdOption<T>            = haxe.ds.Option<T>;
typedef StdEnum<T>              = Enum<T>;
typedef StdEnumValue            = std.EnumValue;
typedef StdDynamic              = Dynamic;

typedef OptionSum<T>            = stx.pico.Option.OptionSum<T>;//Publish Constructors.
typedef Option<T>               = stx.pico.Option<T>;

typedef EitherSum<Ti,Tii>       = stx.pico.Either.EitherSum<Ti,Tii>;
typedef Either<Ti,Tii>          = stx.pico.Either<Ti,Tii>;
//typedef EitherUsing             = stx.pico.Either.EitherUsing;

typedef OutcomeSum<T,E>         = stx.pico.Outcome.OutcomeSum<T,E>;
typedef Outcome<T,E>            = stx.pico.Outcome<T,E>;

typedef Clazz                   = stx.pico.Clazz;
typedef IFaze                   = stx.pico.IFaze;
typedef Identifier              = stx.pico.Identifier;

typedef OptionUsing             = stx.pico.Option.OptionLift;

// typedef Error<E>                = stx.pico.Error<E>;
// typedef ErrorDef<E>             = stx.pico.Error.ErrorDef<E>;
// typedef ErrorApi<E>             = stx.pico.Error.ErrorApi<E>;
// typedef ErrorBase<E>            = stx.pico.Error.ErrorBase<E>;
// typedef ErrorException          = stx.pico.Error.ErrorException;

typedef Apply<P,R>              = stx.pico.Apply<P,R>;
typedef ApplyCls<P,R>           = stx.pico.Apply.ApplyCls<P,R>;
typedef ApplyApi<P,R>           = stx.pico.Apply.ApplyApi<P,R>;

typedef Comply<Pi,Pii,R>              = stx.pico.Comply<Pi,Pii,R>;
typedef ComplyCls<Pi,Pii,R>           = stx.pico.Comply.ComplyCls<Pi,Pii,R>;
typedef ComplyApi<Pi,Pii,R>           = stx.pico.Comply.ComplyApi<Pi,Pii,R>;

typedef React                   = stx.pico.React;
typedef ReactCls                = stx.pico.React.ReactCls;
typedef ReactApi                = stx.pico.React.ReactApi;


typedef ArrayLift               = stx.lift.ArrayLift;
typedef IteratorLift            = stx.lift.IteratorLift;
typedef IterableLift            = stx.lift.IterableLift;

typedef ExceptionDef            = {
  public var message(get,never):String;
	public var stack(get,never):CallStack;
	//public var previous(get,never):Null<Exception>;
	public var native(get,never):Any;
  function details():String;
}
interface ExceptionApi {
  public var message(get,never):String;
	public var stack(get,never):CallStack;
	//public var previous(get,never):Null<Exception>;
	public var native(get,never):Any;
  function details():String;
}