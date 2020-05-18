package stx;

typedef StdInt                  = Int;
typedef StdBool                 = Bool;
typedef StdString               = String;
typedef StdFloat                = Float;
typedef StdDate                 = std.Date;
typedef StdOption<T>            = haxe.ds.Option<T>;
typedef StdEnumValue            = std.EnumValue;
typedef StdArray<T>             = std.Array<T>;

typedef Clazz                   = stx.core.pack.Clazz;

typedef OptionSum<T>            = stx.core.pack.Option.OptionSum<T>;
typedef Option<T>               = stx.core.pack.Option<T>;
typedef OptionLift              = stx.core.pack.Option.OptionLift;

typedef EitherSum<Ti,Tii>       = stx.core.pack.Either.EitherSum<Ti,Tii>;
typedef Either<Ti,Tii>          = stx.core.pack.Either<Ti,Tii>;
typedef EitherLift              = stx.core.pack.Either.EitherLift;

typedef OutcomeSum<T,E>         = stx.core.pack.Outcome.OutcomeSum<T,E>;
typedef Outcome<T,E>            = stx.core.pack.Outcome<T,E>;

typedef ArrayLift               = stx.lift.ArrayLift;