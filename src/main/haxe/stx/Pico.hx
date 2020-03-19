package stx;

typedef PosDef                = stx.pico.type.PosDef;
typedef Pos                   = PosDef;

typedef CoupleDef<Ti,Tii>      = (Ti -> Tii -> Void) -> Void;
typedef Couple<Ti,Tii>         = stx.pico.Couple<Ti,Tii>;


typedef ReductApi<P,R,X>      = stx.pico.type.ReductApi<P,R,X>;
typedef ReductDef<P,R,X>      = stx.pico.type.ReductDef<P,R,X>;
//typedef ReductSum<P,R>      = stx.pico.type.ReductSum<P,R>;
typedef Reduct<P,R,X>         = stx.pico.Reduct<P,R,X>;
typedef EitherDef<Ti,Tii>     = haxe.ds.Either<Ti,Tii>;
typedef Either<Ti,Tii>        = stx.pico.Either<Ti,Tii>;
typedef OptionDef<T>          = stx.pico.type.OptionDef<T>;
typedef Option<T>             = stx.pico.Option<T>;
typedef OutcomeSum<T,E>       = stx.pico.type.OutcomeSum<T,E>;
typedef ResDef<T,E>           = OutcomeSum<T,Err<E>>;
typedef Res<T,E>              = stx.pico.Res<T,E>;
typedef Err<E>                = stx.pico.Err<E>;
typedef Failure<T>            = stx.pico.Failure<T>;
typedef FailCode              = stx.pico.FailCode;
typedef Fault                 = stx.pico.Fault;
typedef Clazz                 = stx.pico.Clazz;
typedef VBlockDef<T>          = Void -> Void;
typedef VBlock<T>             = stx.pico.VBlock<T>;
typedef YDef<P, R>            = Recursive<P -> R>; 
typedef Y<P, R>               = stx.pico.Y<P,R>;
typedef RecursiveDef<P>       = RecursiveDef<P> -> P; 
typedef Recursive<P>          = RecursiveDef<P>;

typedef UsePico               = stx.pico.use.UsePico;
typedef UseCouple             = stx.pico.use.UseCouple;


enum Wildcard{
  __;
}
