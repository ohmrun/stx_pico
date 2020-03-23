package stx.core;


typedef Clazz                   = stx.core.pack.Clazz;

typedef OptionSum<T>            = stx.core.pack.Option.OptionSum<T>;
typedef Option<T>               = stx.core.pack.Option<T>;
typedef OptionLift              = stx.core.pack.Option.OptionLift;

typedef EitherSum<Ti,Tii>       = haxe.ds.Either<Ti,Tii>;
typedef Either<Ti,Tii>          = stx.core.pack.Either<Ti,Tii>;
typedef EitherLift              = stx.core.pack.Either.EitherLift;

typedef OutcomeSum<T,E>         = stx.core.pack.Outcome.OutcomeSum<T,E>;
typedef Outcome<T,E>            = stx.core.pack.Outcome<T,E>;

typedef ArrayLift               = stx.core.pack.Array.ArrayLift;

typedef UsePico                 = stx.core.use.UsePico;