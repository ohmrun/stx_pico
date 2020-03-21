package stx.core.pack.outcome;

class Constructor extends Clazz {
  static public var ZERO(default,never) = new Constructor();
  public var _ =  new Destructure();

  public function lift<T,E>(self:OutcomeSum<T,E>):Outcome<T,E> return new Outcome(self);

  public function success<T,E>(t:T):Outcome<T,E>{
    return lift(Success(t));
  }
  public function failure<T,E>(e:E):Outcome<T,E>{
    return lift(Failure(e));
  }
}