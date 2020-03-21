package stx.core.pack.either;

class Destructure extends Clazz{
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