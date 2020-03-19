package stx.pico;

@:forward abstract Either<Pi,Pii>(EitherDef<Pi,Pii>) from EitherDef<Pi,Pii> to EitherDef<Pi,Pii>{
  public function new(self) this = self;

  static public function lift<Pi,Pii>(self:EitherDef<Pi,Pii>):Either<Pi,Pii> return new Either(self);
  static public var inj(default,null) = new Constructor();

  public function map(fn)     return inj._.map(fn,this);
  public function flat_map(fn)    return inj._.flat_map(fn,this);
  public function fold<Ri>(l:Pi->Ri,r:Pii->Ri)   return inj._.fold(l,r,this);
  public function flip()      return inj._.flip(this);

  public function prj():EitherDef<Pi,Pii> return this;
  private var self(get,never):Either<Pi,Pii>;
  private function get_self():Either<Pi,Pii> return lift(this);
}
private class Constructor extends Clazz{
  public var _(default,null) = new Destructure();
}
private class Destructure extends Clazz{
  public function fold<Pi,Pii,Ri>(lhs:Pi->Ri,rhs:Pii->Ri,self:Either<Pi,Pii>):Ri{
    return switch(self){
      case Left(l)  : lhs(l);
      case Right(r) : rhs(r);
    }
  }
  public function flip<Pi,Pii>(self:Either<Pi,Pii>):Either<Pii,Pi>{
    return fold(
      (l) -> Right(l),
      (r) -> Left(r),
      self
    );
  }
  public function flat_map<Pi,Pii,Ri>(fn:Pii->Either<Pi,Ri>,self:Either<Pi,Pii>):Either<Pi,Ri>{
    return fold(
      Left,
      (r) -> fn(r),
      self
    );
  }
  public function map<Pi,Pii,Ri>(fn:Pii->Ri,self:Either<Pi,Pii>):Either<Pi,Ri>{
    return flat_map(
      (x) -> Right(fn(x)),
      self
    );
  }
}