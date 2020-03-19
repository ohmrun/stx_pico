package stx.pico.option;

class Destructure extends Clazz{
  public function fold<T,U>(ok:T->U,no:Void->U,option:Option<T>):U{
    var ou : Option<U> = option.map(ok);
    return def(no,ou);
  }
  public function fudge<T,E>(?err:Err<E>,opt:Null<Option<T>>):T{
    err = Option._().make(err).defv(__.fault().fail(ERR(E_OptionForcedError)));
    return switch(opt){
      case Some(v)  : v;
      case None     : throw err;
      case null     : throw err;
    }
  }
  /**
		Performs `f` on the contents of `o` if o != None
	**/
  public function map<T, S>(f: T -> S,o: Option<T>): Option<S> {
    return switch (o) {
      case None   : None;
      case Some(v): Some(f(v));
    }
  }
  /**
		Produces the result of `f` which takes the contents of `o` as a parameter.
	**/
  public function flat_map<T, S>(f: T -> Option<S>,o: Option<T>): Option<S> {
    return Option._().flatten(map(f, o));
  }
  /**
		Produces the value of `o` if not None, the result of `thunk` otherwise.
	**/
  public function def<T>(?thunk: Void->T,o: Option<T>): T {
    return switch(o) {
      case None:
        if(
          thunk == null
        ){
          thunk = function(){
            return throw __.fault().fail(ERR(E_UnexpectedNullValueEncountered));
          }
        } 
        thunk();
      case Some(v): v;
    }
  }
  /**
		Produces `o1` if it is Some, the result of `thunk` otherwise.
	**/
  public function or<T>(thunk: Void -> Option<T>, o1: Option<T>): Option<T> {
    return switch (o1) {
      case None: thunk();

      case Some(_): o1;
    }
  }
	/**
		Produces an Array of length 0 if `o` is None, length 1 otherwise.
	**/
  public function toArray<T>(o: Option<T>): Array<T> {
    return switch (o) {
      case None:    [];
      case Some(v): [v];
    }
  }

  public function filter<T>(fn:T->Bool,o:Option<T>):Option<T>{
    return flat_map(
      (v) -> fn(v) ? Some(v) : None,
      o
    );
  }
  // /**
	// 	Produces a Couple of `o1` and `o2`.
	// **/
  // public function zip<T, S>(that: Option<S>,self: Option<T>):Option<Couple<T,S>> {
  //   return switch([self,that]){
  //     case [Some(l),Some(r)]  : Some(__.couple(l,r));
  //     default                 : None;
  //   }
  // }
  /**
		Produces one or other value if only one is defined, or calls `fn` on the two and returns the result
	**/
  public function merge<A>(fn : A -> A -> A,o2:Option<A>,o1:Option<A>):Option<A>{
    return zip(o1,o2).map(
      Couple._()._.decouple.bind(fn)
    ).or(()->o1).or(()->o2);
  }
  public function is_defined<T>(self:Option<T>){
    return switch(self){
      case null     : false;
      case Some(_)  : true;
      default       : false;
    }
  }
  public function iterator<T>(self:Option<T>):Iterator<T>{
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
