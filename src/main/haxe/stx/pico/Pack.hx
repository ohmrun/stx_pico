package stx.pico;


typedef EitherDef<Ti,Tii>       = haxe.ds.Either<Ti,Tii>;
typedef Either<Ti,Tii>          = stx.pico.pack.Either<Ti,Tii>;

typedef OptionSum<T>            = stx.pico.type.OptionSum<T>;
typedef Option<T>               = stx.pico.pack.Option<T>;

typedef OutcomeSum<T,E>         = stx.pico.type.OutcomeSum<T,E>;
typedef Outcome<T,E>            = stx.pico.pack.Outcome<T,E>;

typedef Clazz                   = stx.pico.pack.Clazz;

typedef UseEitherImplementation = stx.pico.pack.either.Implementation;
typedef UseOptionImplementation = stx.pico.pack.option.Implementation;
typedef UseArrayImplementation  = stx.pico.pack.array.Implementation;

typedef UsePico                 = stx.pico.use.UsePico;