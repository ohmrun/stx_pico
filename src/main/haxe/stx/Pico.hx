package stx;

typedef PosDef                = stx.pico.type.PosDef;
typedef Pos                   = PosDef;


typedef EitherDef<Ti,Tii>     = haxe.ds.Either<Ti,Tii>;
typedef Either<Ti,Tii>        = stx.pico.Either<Ti,Tii>;
typedef OptionDef<T>          = stx.pico.type.OptionDef<T>;
typedef Option<T>             = stx.pico.Option<T>;
typedef OutcomeSum<T,E>       = stx.pico.type.OutcomeSum<T,E>;
typedef Clazz                 = stx.pico.Clazz;


typedef UseEitherImplementation = stx.pico.either.Implementation;
typedef UseOptionImplementation = stx.pico.option.Implementation;
typedef UsePico                 = stx.pico.use.UsePico;



enum Wildcard{
  __;
}
