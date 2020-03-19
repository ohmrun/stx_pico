package stx.pico;

import stx.pico.outcome.Constructor;

abstract Res<T,E>(ResDef<T,E>) from ResDef<T,E> to ResDef<T,E>{
  public function new(self) this = self;
  static public function _() return Constructor.ZERO;

  static public function lift<T,E>(self:ResDef<T,E>):Res<T,E>         return _().lift(self);
  static public function success<T,E>(t:T):Res<T,E>                      return _().success(t);
  static public function failure<T,E>(e:Err<E>):Res<T,E>                 return _().failure(e);

  public function errata<EE>(fn:Err<E>->Err<EE>):Res<T,EE>               return _()._.errata(fn,self);
  public function map<TT>(fn:T->TT)                                         return _()._.map(fn,self);
  public function flat_map<TT>(fn:T->Res<TT,E>)                          return _()._.flat_map(fn,self);
  public function fold<Z>(fn:T->Z,er:Err<E>->Z):Z                           return _()._.fold(fn,er,self);
  public function zip<TT>(that:Res<TT,E>):Res<Couple<T,TT>,E>          return _()._.zip(that,self);
  
  public function fudge():T                                                 return _()._.fudge(self);
  public function elide():Res<Dynamic,E>                                 return _()._.elide(this);

  public function prj():ResDef<T,E> return this;
  private var self(get,never):Res<T,E>;
  private function get_self():Res<T,E> return lift(this);
}

