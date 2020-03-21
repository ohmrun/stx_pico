package stx.core.pack.option;

class Implementation{
  static public function _() return Constructor.ZERO._;

  static public function map<T,TT>(self:OptionSum<T>,fn:T->TT):Option<TT>                         return _().map(fn,self);  
  static public function flat_map<T,TT>(self:OptionSum<T>,fn:T->Option<TT>):Option<TT>            return _().flat_map(fn,self);
  static public function or<T>(self:OptionSum<T>,thk:Void->OptionSum<T>):Option<T>                return _().or(thk,self);
  static public function filter<T>(self:OptionSum<T>,fn:T->Bool):Option<T>                        return _().filter(fn,self);
  static public function def<T>(self:OptionSum<T>,f:Void->T):T                                    return _().def(f,self);
  static public function defv<T>(self:OptionSum<T>,v:T):T                                         return _().def(()->v,self);
  
  static public function is_defined<T>(self:OptionSum<T>):Bool                                    return _().is_defined(self);
  static public function fold<T,TT>(self:OptionSum<T>,ok:T->TT,no:Void->TT):TT                    return _().fold(ok,no,self);
  static public function iterator<T>(self:OptionSum<T>):Iterator<T>                               return _().iterator(self);
  static public function array<T>(self:OptionSum<T>):Array<T>                                     return Lambda.array({ iterator : self.iterator });
  static public function merge<T>(self:OptionSum<T>,that:OptionSum<T>,fn:T->T->T):Option<T>       return _().merge(that,fn,self);

  static public function prj<T>(self:Option<T>):haxe.ds.Option<T>                                 return self;
}