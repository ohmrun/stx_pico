package stx.core.pack;

@:using(stx.core.pack.Either.EitherLift)
@:forward abstract Either<Pi,Pii>(EitherSum<Pi,Pii>) from EitherSum<Pi,Pii> to EitherSum<Pi,Pii>{
  static public var _ (default,never) = EitherLift;
  public function new(self) this = self;

  static public function lift<Pi,Pii>(self:EitherSum<Pi,Pii>):Either<Pi,Pii> return new Either(self);
  

  public function prj():EitherSum<Pi,Pii> return this;
}
class EitherLift{
  static public function fold<Ti,Tii,R>(self:EitherSum<Ti,Tii>,lhs:Ti->R,rhs:Tii->R):R{
    return switch(self){
      case Left(l)  : lhs(l);
      case Right(r) : rhs(r);
    }
  }
  static public function flat_map<Ti,Tii,R>(self:Either<Ti,Tii>,fn:Tii->Either<Ti,R>):Either<Ti,R>{
    return fold(self,Left,(r) -> fn(r));
  }
  static public function map<Ti,Tii,R>(self:Either<Ti,Tii>,fn:Tii->R):Either<Ti,R>{
    return flat_map(self,(x) -> Right(fn(x)));
  }
  static public function flip<Ti,Tii>(self:Either<Ti,Tii>):Either<Tii,Ti>{
    return fold(self,(l) -> Right(l),(r) -> Left(r));
  }
}