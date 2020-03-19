package stx.pico.outcome;

class Constructor extends Clazz {
  static public var ZERO(default,never) = new Constructor();
  public var _ =  new Destructure();

  public function lift<T,E>(self:OutcomeSum<T,Err<E>>):Res<T,E> return new Res(self);

  public function success<T,E>(t:T):Res<T,E>{
    return lift(Success(t));
  }
  public function failure<T,E>(e:Err<E>):Res<T,E>{
    return lift(Failure(e));
  }
}