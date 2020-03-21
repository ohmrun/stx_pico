package stx.core;

typedef EitherDef<Ti,Tii>       = haxe.ds.Either<Ti,Tii>;
typedef Either<Ti,Tii>          = stx.core.pack.Either<Ti,Tii>;

typedef OptionSum<T>            = stx.core.type.OptionSum<T>;
typedef Option<T>               = stx.core.pack.Option<T>;

typedef OutcomeSum<T,E>         = stx.core.type.OutcomeSum<T,E>;
typedef Outcome<T,E>            = stx.core.pack.Outcome<T,E>;

typedef Clazz                   = stx.core.pack.Clazz;

typedef UseEitherImplementation = stx.core.pack.either.Implementation;
typedef UseOptionImplementation = stx.core.pack.option.Implementation;
typedef UseArrayImplementation  = stx.core.pack.array.Implementation;

typedef UsePico                 = stx.core.use.UsePico;