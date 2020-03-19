package stx.pico.option;

class Implementation{
  static public function _() return Constructor.ZERO._;

  static public function map<T,TT>(self:OptionDef<T>,fn:T->TT):Option<TT>                         return _().map(fn,self);  
  static public function flat_map<T,TT>(self:OptionDef<T>,fn:T->Option<TT>):Option<TT>            return _().flat_map(fn,self);
  static public function or<T>(self:OptionDef<T>,thk:Void->OptionDef<T>):Option<T>                return _().or(thk,self);
  static public function filter<T>(self:OptionDef<T>,fn:T->Bool):Option<T>                        return _().filter(fn,self);
  static public function def<T>(self:OptionDef<T>,f:Void->T):T                                    return _().def(f,self);
  static public function defv<T>(self:OptionDef<T>,v:T):T                                         return _().def(()->v,self);
  
  static public function is_defined<T>(self:OptionDef<T>):Bool                                    return _().is_defined(self);
  static public function fold<T,TT>(self:OptionDef<T>,ok:T->TT,no:Void->TT):TT                    return _().fold(ok,no,self);
  static public function iterator<T>(self:OptionDef<T>):Iterator<T>                               return _().iterator(self);
  static public function array<T>(self:OptionDef<T>):Array<T>                                     return Lambda.array({ iterator : self.iterator });
  static public function merge<T>(self:OptionDef<T>,that:OptionDef<T>,fn:T->T->T):Option<T>       return _().merge(that,fn,self);

  static public function prj<T>(self:Option<T>):haxe.ds.Option<T>                                 return self;
}