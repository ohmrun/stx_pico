package stx;

typedef StdInt                  = Int;
typedef StdBool                 = Bool;
typedef StdString               = String;
typedef StdFloat                = Float;
typedef StdDate                 = std.Date;
typedef StdOption<T>            = haxe.ds.Option<T>;
typedef StdEnumValue            = std.EnumValue;
typedef StdArray<T>             = std.Array<T>;

typedef Clazz                   = stx.pico.Clazz;

typedef OptionSum<T>            = stx.pico.Option.OptionSum<T>;
typedef Option<T>               = stx.pico.Option<T>;
typedef OptionLift              = stx.pico.Option.OptionLift;

typedef EitherSum<Ti,Tii>       = stx.pico.Either.EitherSum<Ti,Tii>;
typedef Either<Ti,Tii>          = stx.pico.Either<Ti,Tii>;
typedef EitherLift              = stx.pico.Either.EitherLift;

typedef OutcomeSum<T,E>         = stx.pico.Outcome.OutcomeSum<T,E>;
typedef Outcome<T,E>            = stx.pico.Outcome<T,E>;

typedef ArrayLift               = stx.lift.ArrayLift;