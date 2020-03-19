package stx.pico.option;

class Destructure extends Clazz{
  public function fold<T,U>(ok:T->U,no:Void->U,option:OptionDef<T>):U{
    var ou : OptionDef<U> = option.map(ok);
    return def(no,ou);
  }
  /**
		Performs `f` on the contents of `o` if o != None
	**/
  public function map<T, S>(f: T -> S,o: OptionDef<T>): OptionDef<S> {
    return switch (o) {
      case None   : None;
      case Some(v): Some(f(v));
    }
  }
  /**
		Produces the result of `f` which takes the contents of `o` as a parameter.
	**/
  public function flat_map<T, S>(f: T -> OptionDef<S>,o: OptionDef<T>): OptionDef<S> {
    return stx.pico.Option._().flatten(map(f, o));
  }
  /**
		Produces the value of `o` if not None, the result of `thunk` otherwise.
	**/
  public function def<T>(?thunk: Void->T,o: OptionDef<T>): T {
    return switch(o) {
      case None   : 
        thunk();
      case Some(v): v;
    }
  }
  /**
		Produces `o1` if it is Some, the result of `thunk` otherwise.
	**/
  public function or<T>(thunk: Void -> OptionDef<T>, o1: OptionDef<T>): OptionDef<T> {
    return switch (o1) {
      case None: thunk();

      case Some(_): o1;
    }
  }
	/**
		Produces an Array of length 0 if `o` is None, length 1 otherwise.
	**/
  public function toArray<T>(o: OptionDef<T>): Array<T> {
    return switch (o) {
      case None:    [];
      case Some(v): [v];
    }
  }

  public function filter<T>(fn:T->Bool,o:OptionDef<T>):OptionDef<T>{
    return flat_map(
      (v) -> fn(v) ? Some(v) : None,
      o
    );
  }
  /**
		Produces one or other value if only one is defined, or calls `fn` on the two and returns the result
	**/
  public function merge<A>(that:OptionDef<A>,fn : A -> A -> A,self:OptionDef<A>):OptionDef<A>{
    return switch([self,that]){
      case [Some(l),Some(r)]  : Some(fn(l,r));
      case [Some(l),None]     : Some(l);
      case [None,Some(r)]     : Some(r);
      default : None;
    }
  }
  public function is_defined<T>(self:OptionDef<T>){
    return switch(self){
      case null     : false;
      case Some(_)  : true;
      default       : false;
    }
  }
  public function iterator<T>(self:OptionDef<T>):Iterator<T>{
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
