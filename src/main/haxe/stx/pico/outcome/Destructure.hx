package stx.pico.outcome;

class Destructure extends Clazz{
  public function errata<T,E,EE>(fn:Err<E>->Err<EE>,self:Res<T,E>):Res<T,EE>{
    return Res.lift(
      self.fold(
        (t) -> Success(t),
        (e) -> Failure(fn(e))
      )
    );
  }
  public function map<T,E,TT>(fn:T->TT,self:Res<T,E>):Res<TT,E>{
    return flat_map(
      (x) -> Success(fn(x)),
      self
    );
  }
  public function flat_map<T,E,TT>(fn:T->Res<TT,E>,self:Res<T,E>):Res<TT,E>{
    return Res._().lift(
      self.fold(
        (t) -> fn(t),
        (e) -> __.failure(e)
      )
    );
  }
  public function fold<T,E,Z>(fn:T->Z,er:Err<E>->Z,self:Res<T,E>):Z{
    return switch(self){
      case Success(t) : fn(t);
      case Failure(e) : er(e);
    }
  }
  public function zip<T,TT,E>(that:Res<TT,E>,self:Res<T,E>):Res<Couple<T,TT>,E>{
    return switch([self,that]){
      case [Failure(e),Failure(ee)]     : Failure(e.next(ee));
      case [Failure(e),_]               : Failure(e);
      case [_,Failure(e)]               : Failure(e);
      case [Success(t),Success(tt)]     : Success(__.couple(t,tt));
    }
  }
  public function fudge<T,E>(self:Res<T,E>):T{
    return fold(
      (t) -> t,
      (e) -> throw(e),
      self
    );
  }
  public function elide<T,E>(self:Res<T,E>):Res<Dynamic,E>{
    return fold(
      (t) -> Failure((t:Dynamic)),
      (e) -> Success(e),
      self
    );
  }
}