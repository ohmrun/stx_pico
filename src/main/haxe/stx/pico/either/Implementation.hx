package stx.pico.either;

class Implementation{
  static public function _() return Either._()._;
  
  static public function map<Ti,Tii,Tiii>(self:EitherDef<Ti,Tii>,fn):Either<Ti,Tiii>                                return _().map(fn,self);
  static public function flat_map<Ti,Tii,Tiii>(self:EitherDef<Ti,Tii>,fn:Tii->EitherDef<Ti,Tiii>):Either<Ti,Tiii>   return _().flat_map(fn,self);
  static public function fold<Ti,Tii,R>(self:EitherDef<Ti,Tii>,l:Ti->R,r:Tii->R):R                                  return _().fold(l,r,self);
  static public function flip<Ti,Tii>(self:EitherDef<Ti,Tii>):Either<Tii,Ti>                                        return _().flip(self);
}