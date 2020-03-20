package stx.pico.pack.outcome;

class Destructure extends Clazz{
  public function map<T,E,TT>(fn:T->TT,self:OutcomeSum<T,E>):Outcome<TT,E>{
    return flat_map(
      (x) -> Success(fn(x)),
      self
    );
  }
  public function flat_map<T,E,TT>(fn:T->OutcomeSum<TT,E>,self:OutcomeSum<T,E>):Outcome<TT,E>{
    return Outcome._().lift(
      fold(
        (t) -> fn(t),
        (e) -> Failure(e),
        self
      )
    );
  }
  public function fold<T,E,Z>(fn:T->Z,er:E->Z,self:OutcomeSum<T,E>):Z{
    return switch(self){
      case Success(t) : fn(t);
      case Failure(e) : er(e);
    }
  }
  public function fudge<T,E>(self:OutcomeSum<T,E>):T{
    return fold(
      (t) -> t,
      (e) -> throw(e),
      self
    );
  }
  public function elide<T,E>(self:OutcomeSum<T,E>):Outcome<Dynamic,E>{
    return fold(
      (t) -> Failure((t:Dynamic)),
      (e) -> Success(e),
      self
    );
  }
}