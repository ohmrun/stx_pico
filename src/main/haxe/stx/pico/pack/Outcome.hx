package stx.pico.pack;

import stx.pico.pack.outcome.Constructor;

abstract Outcome<T,E>(OutcomeSum<T,E>) from OutcomeSum<T,E> to OutcomeSum<T,E>{
  public function new(self) this = self;
  static public function _() return Constructor.ZERO;

  static public function lift<T,E>(self:OutcomeSum<T,E>):Outcome<T,E>         return _().lift(self);
  static public function success<T,E>(t:T):Outcome<T,E>                       return _().success(t);
  static public function failure<T,E>(e:E):Outcome<T,E>                       return _().failure(e);

  public function map<TT>(fn:T->TT)                                           return _()._.map(fn,self);
  public function flat_map<TT>(fn:T->Outcome<TT,E>)                           return _()._.flat_map(fn,self);
  public function fold<Z>(fn:T->Z,er:E->Z):Z                                  return _()._.fold(fn,er,self);
  
  public function fudge():T                                                   return _()._.fudge(self);
  public function elide():Outcome<Dynamic,E>                                  return _()._.elide(this);

  public function prj():OutcomeSum<T,E> return this;
  private var self(get,never):Outcome<T,E>;
  private function get_self():Outcome<T,E> return lift(this);
}

