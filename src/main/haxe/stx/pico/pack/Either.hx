package stx.pico.pack;

import stx.pico.pack.either.Constructor;
@:using(stx.pico.pack.either.Implementation)
@:forward abstract Either<Pi,Pii>(EitherDef<Pi,Pii>) from EitherDef<Pi,Pii> to EitherDef<Pi,Pii>{
  static public inline function _() return Constructor.ZERO;
  public function new(self) this = self;

  static public function lift<Pi,Pii>(self:EitherDef<Pi,Pii>):Either<Pi,Pii> return new Either(self);
  

  public function prj():EitherDef<Pi,Pii> return this;
}