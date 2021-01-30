package stx;

typedef StdArray<T>             = std.Array<T>;
typedef StdString               = std.String;
typedef StdInt                  = Int;
typedef StdFloat                = Float;
typedef StdBool                 = Bool;
typedef StdDate                 = Date;
typedef StdOption<T>            = haxe.ds.Option<T>;
typedef StdEnumValue            = std.EnumValue;

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
typedef ArrayUsing              = stx.lift.ArrayLift;

