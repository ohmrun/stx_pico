package stx.pico.option;

class Implementation{
  static public function _() return Constructor.ZERO._;

  static public function map<T,TT>(self:OptionDef<T>,fn:T->TT):Option<TT>                         return _()._.map(fn,this);  
  static public function flat_map<T,TT>(self:OptionDef<T>,fn:T->Option<TT>)                       return _()._.flat_map(fn,this);
  static public function or<T>(self:OptionDef<T>,thk:Void->OptionDef<T>):OptionDef<T>             return _()._.or(thk,this);
  //static public function zip<TT>(self:OptionDef<T>,that:OptionDef<TT>):OptionDef<Couple<T,TT>>    return _()._.zip(that,this);
  static public function filter<T>(self:OptionDef<T>,fn:T->Bool)                                  return _()._.filter(fn,this);
  static public function def<T>(self:OptionDef<T>,f:Void->T)                                      return _()._.def(f,this);
  static public function defv<T>(self:OptionDef<T>,v:T)                                           return _()._.def(()->v,this);
  static public function fudge<T>(self:OptionDef<T>,?pos:Pos)                                     return _()._.fudge(this);
  static public function is_defined(self:OptionDef<T>)                                            return _()._.is_defined(this);
  static public function fold<T,TT>(self:OptionDef<T>,ok:T->TT,no:Void->TT):U                     return _()._.fold(ok,no,this);
  static public function iterator<T>(self:OptionDef<T>):Iterator<T>                               return _()._.iterator(this);
  static public function array<T>():Array<T>                                                      return Lambda.array({ iterator : iterator });
  static public function merge<T>(self:OptionDef<T>,that:OptionDef<T>,fn:T->T->T)                 return _()._.merge(fn,that,this);

  static public function prj(self:OptionDef<T>):haxe.ds.Option<T>                                 return this;
}