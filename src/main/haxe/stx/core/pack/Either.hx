package stx.core.pack;

typedef EitherSum<Ti,Tii>       = haxe.ds.Either<Ti,Tii>;

@:using(stx.core.pack.Either.EitherLift)
@:forward abstract Either<Pi,Pii>(EitherSum<Pi,Pii>) from EitherSum<Pi,Pii> to EitherSum<Pi,Pii>{
  static public var _ (default,never) = EitherLift;
  public function new(self) this = self;

  static public function lift<Pi,Pii>(self:EitherSum<Pi,Pii>):Either<Pi,Pii> return new Either(self);
  

  @:noUsing inline static public function left<Ti,Tii>(tI:Ti):Either<Ti,Tii>{
    return Left(tI);
  }
  @:noUsing inline static public function right<Ti,Tii>(tII:Tii):Either<Ti,Tii>{
    return Right(tII);
  }

  public function prj():EitherSum<Pi,Pii> return this;
}
class EitherLift{
  /**
   * Applies `lhs` if the value is `Left` and `rhs` if the value is `Right`, returning the result.
  **/
  static public function fold<Ti,Tii,R>(self:EitherSum<Ti,Tii>,lhs:Ti->R,rhs:Tii->R):R{
    return switch(self){
      case Left(l)  : lhs(l);
      case Right(r) : rhs(r);
    }
  }
  /**
    applies `fn` if the value is `Right`, producing `Right(R)`
  **/
  static public function map<Ti,Tii,R>(self:Either<Ti,Tii>,fn:Tii->R):Either<Ti,R>{
    return flat_map(self,(x) -> Right(fn(x)));
  }
  /**
    * `map`s and then `flatten` the `Right` value if it exists, or pass the `Left` untouched.
  **/
  static public function flat_map<Ti,Tii,R>(self:Either<Ti,Tii>,fn:Tii->Either<Ti,R>):Either<Ti,R>{
    return fold(self,Left,(r) -> fn(r));
  }
  /**
    makes a `Left` a `Right` and vice-versa.
  **/
  static public function flip<Ti,Tii>(self:Either<Ti,Tii>):Either<Tii,Ti>{
    return fold(self,(l) -> Right(l),(r) -> Left(r));
  }
}