package stx.core.pack.option;

class Destructure extends Clazz{
  public function fold<T,U>(ok:T->U,no:Void->U,option:OptionSum<T>):U{
    var ou : OptionSum<U> = option.map(ok);
    return def(no,ou);
  }
  /**
		Performs `f` on the contents of `o` if o != None
	**/
  public function map<T, S>(f: T -> S,o: OptionSum<T>): OptionSum<S> {
    return switch (o) {
      case None   : None;
      case Some(v): Some(f(v));
    }
  }
  /**
		Produces the result of `f` which takes the contents of `o` as a parameter.
	**/
  public function flat_map<T, S>(f: T -> OptionSum<S>,o: OptionSum<T>): OptionSum<S> {
    return stx.core.pack.Option._().flatten(map(f, o));
  }
  /**
		Produces the value of `o` if not None, the result of `thunk` otherwise.
	**/
  public function def<T>(?thunk: Void->T,o: OptionSum<T>): T {
    return switch(o) {
      case None   : 
        thunk();
      case Some(v): v;
    }
  }
  /**
		Produces `o1` if it is Some, the result of `thunk` otherwise.
	**/
  public function or<T>(thunk: Void -> OptionSum<T>, o1: OptionSum<T>): OptionSum<T> {
    return switch (o1) {
      case None: thunk();

      case Some(_): o1;
    }
  }
	/**
		Produces an Array of length 0 if `o` is None, length 1 otherwise.
	**/
  public function toArray<T>(o: OptionSum<T>): Array<T> {
    return switch (o) {
      case None:    [];
      case Some(v): [v];
    }
  }

  public function filter<T>(fn:T->Bool,o:OptionSum<T>):OptionSum<T>{
    return flat_map(
      (v) -> fn(v) ? Some(v) : None,
      o
    );
  }
  /**
		Produces one or other value if only one is defined, or calls `fn` on the two and returns the result
	**/
  public function merge<A>(that:OptionSum<A>,fn : A -> A -> A,self:OptionSum<A>):OptionSum<A>{
    return switch([self,that]){
      case [Some(l),Some(r)]  : Some(fn(l,r));
      case [Some(l),None]     : Some(l);
      case [None,Some(r)]     : Some(r);
      default : None;
    }
  }
  public function is_defined<T>(self:OptionSum<T>){
    return switch(self){
      case null     : false;
      case Some(_)  : true;
      default       : false;
    }
  }
  public function iterator<T>(self:OptionSum<T>):Iterator<T>{
    var done = false;

    return {
      hasNext : function(){
        return !done && switch(self){
          case Some(_)    : true;
          default         : false; 
        }
      },
      next    : function(){
        done = true;
        return switch(self){
          case haxe.ds.Option.Some(v)  : v;
          default       : null;
        }
      }
    };
  }
}
