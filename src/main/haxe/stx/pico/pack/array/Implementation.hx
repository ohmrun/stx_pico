package stx.pico.pack.array;

import stx.pico.alias.StdArray;

class Implementation{
  static public function _() return Constructor.ZERO._;

  static public function snoc<T>(self:StdArray<T>,t:T):Array<T>                                         return _().snoc(t,self);
  static public function cons<T>(self:StdArray<T>,t:T):Array<T>                                         return _().cons(t,self);
  static public function head<T>(self:StdArray<T>):Option<T>                                            return _().head(self);
  static public function tail<T>(self:StdArray<T>):Array<T>                                             return _().tail(self);
  static public function last<T>(self:StdArray<T>):Option<T>                                            return _().last(self);
  static public function concat<T>(self:StdArray<T>,that:Array<T>):Array<T>                             return _().concat(that,self);

  static public function map<T,Ti>(self:StdArray<T>,fn:T->Ti):Array<Ti>                                 return _().map(fn,self);
  static public function mapi<T,Ti>(self:StdArray<T>,fn:Int->T->Ti):Array<Ti>                           return _().mapi(fn,self);
  static public function flat_map<T,Ti>(self:StdArray<T>,fn:T->Iterable<Ti>):Array<Ti>                  return _().flat_map(fn,self);

  static public function lfold<T,Ti>(self:StdArray<T>,fn:T->Ti->Ti,memo:Ti):Ti                          return _().lfold(fn,memo,self);
  static public function lfold1<T>(self:StdArray<T>,fn:T->T->T):Option<T>                               return _().lfold1(fn,self);
  static public function rfold<T,Ti>(self:StdArray<T>,fn:T->Ti->Ti,z:Ti):Ti                             return _().rfold(fn,z,self);
  static public function rfold1<T>(self:StdArray<T>,fn:T->T->T):Option<T>                               return _().rfold1(fn,self);

  static public function filter<T>(self:StdArray<T>,fn:T->Bool):Array<T>                                return _().filter(fn,self);
  static public function map_filter<T,Ti>(self:StdArray<T>,fn:T->Option<Ti>):Array<Ti>                  return _().map_filter(fn,self);
  static public function whilst<T>(self:StdArray<T>,fn:T->Bool):Array<T>                                return _().whilst(fn,self);
  
  static public function ltaken<T>(self:StdArray<T>,n):Array<T>                                         return _().ltaken(n,self);
  static public function ldropn<T>(self:StdArray<T>,n):Array<T>                                         return _().ldropn(n,self);
  static public function rdropn<T>(self:StdArray<T>,n:Int):Array<T>                                     return _().rdropn(n,self);
  


  static public function is_defined<T>(self:StdArray<T>):Bool                                           return _().is_defined(self);
  static public function search<T>(self:StdArray<T>,fn:T->Bool):Option<T>                               return _().search(fn,self);
  static public function all<T>(self:StdArray<T>,fn:T->Bool):Bool                                       return _().all(fn,self);
  static public function any<T>(self:StdArray<T>,fn:T->Bool)                                            return _().any(fn,self);

  
  static public function zip_with<T,Ti,Tii>(self:StdArray<T>,that:StdArray<Ti>,fn:T->Ti->Tii):Array<Tii>   return _().zip_with(fn,that,self);
  static public function cross_with<T,Ti,Tii>(self:StdArray<T>,that:StdArray<Ti>,fn:T->Ti->Tii):Array<Tii> return _().cross_with(that,fn,self);  

  static public function snapshot<T>(self:StdArray<T>):StdArray<T>                                      return _().snapshot(self);
  static public function reversed<T>(self:StdArray<T>):Array<T>                                         return _().reversed(self);

  static public function elide<T>(self:StdArray<T>):Array<Dynamic>                                      return map(self,(v) -> (v:Dynamic));
  static public function iterator<T>(self:StdArray<T>):Iterator<T>                                      return self.iterator();
  static public function prj<T>(self:StdArray<T>):StdArray<T>                                           return self;

  static public function toIterable<T>(self:StdArray<T>):Iterable<T>                                    return self;
}