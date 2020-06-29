package stx.core.pack;


enum OutcomeSum<T,E>{
  Success(t:T);
  Failure(e:E);
}

@:using(stx.core.pack.Outcome.OutcomeLift)
abstract Outcome<T,E>(OutcomeSum<T,E>) from OutcomeSum<T,E> to OutcomeSum<T,E>{
  public function new(self) this = self;
  static public var _(default,never) = OutcomeLift;

  static public function lift<T,E>(self:OutcomeSum<T,E>):Outcome<T,E> return new Outcome(self);

  @:noUsing static public function success<T,E>(t:T):Outcome<T,E>{
    return lift(Success(t));
  }
  @:noUsing static public function failure<T,E>(e:E):Outcome<T,E>{
    return lift(Failure(e));
  }
  public function prj():OutcomeSum<T,E> return this;
  private var self(get,never):Outcome<T,E>;
  private function get_self():Outcome<T,E> return lift(this);
}
class OutcomeLift{
  static public function map<T,E,TT>(self:OutcomeSum<T,E>,fn:T->TT):Outcome<TT,E>{
    return flat_map(self,(x) -> Success(fn(x)));
  }
  static public function flat_map<T,E,TT>(self:OutcomeSum<T,E>,fn:T->OutcomeSum<TT,E>):Outcome<TT,E>{
    return Outcome.lift(fold(self,(t) -> fn(t),(e) -> Failure(e)));
  }
  inline static public function fold<T,E,TT>(self:OutcomeSum<T,E>,fn:T->TT,er:E->TT):TT{
    return switch(self){
      case Success(t) : fn(t);
      case Failure(e) : er(e);
    }
  }
  static inline public function fudge<T,E>(self:OutcomeSum<T,E>):T{
    return fold(self,(t) -> t,(e) -> throw(e));
  }
  static public function elide<T,E>(self:OutcomeSum<T,E>):Outcome<Dynamic,E>{
    return fold(self,
      (t) -> Failure((t:Dynamic)),
      (e) -> Success(e)
    );
  }
}