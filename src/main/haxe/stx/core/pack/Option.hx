package stx.core.pack;

typedef OptionSum<T> = haxe.ds.Option<T>;

@:using(stx.core.pack.Option.OptionLift)
abstract Option<T>(OptionSum<T>) from OptionSum<T> to OptionSum<T>{
  static public var _(default,never) = OptionLift;

  public function new(self) this = self;
  @:noUsing @:from static public function fromNullT<T>(v:Null<T>):Option<T> return Option.make(v);

  /**
	 * Produces Option.Some(t) if `t` is not null, Option.None otherwise.
	**/
  static public function make<T>(t: T): Option<T> {
    return if (t == null) None; else Some(t);
  }
  /**
	 * Produces an Option where `self` may contain another Option.
	**/
  static public function flatten<T>(self: Option<Option<T>>): Option<T> {
    return switch (self.prj()) {
      case None       : None;
      case Some(next) : next;
    }
  }
}
class OptionLift{
  static public function fold<T,TT>(self:OptionSum<T>,ok:T->TT,no:Void->TT):TT{
    return switch(self){
      case Some(t)  : ok(t);
      case None     : no();
     }
  }
  static public function foldv<T,TT>(self:OptionSum<T>,ok:T->TT,no:TT):TT{
    return fold(self,ok,()->no);
  }
  /**
	 * Performs `f` on the contents of `self` if `self != None`
	**/
  static public function map<T, TT>(self: OptionSum<T>,f: T -> TT):Option<TT> {
    return fold(self,(t) -> Some(f(t)),()->None);
  }
  /**
	 * Produces the `Option` result of `f` which takes the contents of `self` as a parameter
	**/
  static public function flat_map<T, TT>(self: OptionSum<T>,f: T -> Option<TT>): Option<TT> {
    var out = map(self,f);
    return Option.flatten(out);
  }
  /**
	 * Produces `self` if it is `Some(x)`, the result of `thunk` otherwise.
	**/
  static public function or<T>(self: OptionSum<T>, thunk: Void -> OptionSum<T>): Option<T> {
    return fold(self,Some,thunk);
  }
  static public function filter<T>(self:OptionSum<T>,fn:T->Bool):Option<T>{
    return flat_map(self,(v) -> fn(v) ? Some(v) : None);
  }
  /**
	 * Produces the value of `self` if not `None`, the result of `thunk` otherwise.
	**/
  static public function def<T>(self: OptionSum<T>, thunk: Void->T): T {
    return switch(self){

      case Some(v)  : v;
      default       : thunk();
    }
  }
  static public function defv<T>(self:OptionSum<T>,v:T):T
    return def(self,()->v);
  
  static public function is_defined<T>(self:OptionSum<T>){
    return fold(self,(_) -> true,() -> false);
  }
  static public function iterator<T>(self:OptionSum<T>):Iterator<T>{
    var done = false;
    return {
      hasNext : function(){
        return !done && is_defined(self);
      },
      next    : function(){
        done = true;
        return defv(self,null);
      }
    };
  }
  /**
	 * Produces one or other value if only one is defined, or calls `fn` on the two and returns the result
	**/
  static public function merge<T>(self:OptionSum<T>,that:OptionSum<T>,fn : T -> T -> T):OptionSum<T>{
    return switch([self,that]){
      case [Some(l),Some(r)]  : Some(fn(l,r));
      case [Some(l),None]     : Some(l);
      case [None,Some(r)]     : Some(r);
      default                 : None;
    }
  }
  /**
	 * Produces an `Array` of length 0 if `self` is None, length 1 otherwise.
	**/
  static public function toArray<T>(self: OptionSum<T>): Array<T> {
    return switch (self) {
      case None:    [];
      case Some(v): [v];
    }
  }
  static public function prj<T>(self:Option<T>):haxe.ds.Option<T>                                 return self;
}