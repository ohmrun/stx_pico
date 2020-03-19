package stx.pico.use;

class UsePico{
  static public function option<T>(wildcard:Wildcard,v:T):Option<T>{
    return switch(v){
      case null : None;
      default   : Some(v);
    }
  }
  static public function success<T,E>(wildcard:Wildcard,t:T):Res<T,E>{
    return Res.success(t);
  }
  static public function failure<T,E>(wildcard:Wildcard,e:Err<E>):Res<T,E>{
    return Res.failure(e);
  }
  static public function fault(stx:Wildcard,?pos:Pos):Fault{
    return new Fault(pos);
  }
  /**
		Returns a unique identifier, each `x` replaced with a hex character.
	**/
  static public function uuid(v:Wildcard, value : String = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx') : String {
    var reg = ~/[xy]/g;
    return reg.map(value, function(reg) {
        var r = Std.int(Math.random() * 16) | 0;
        var v = reg.matched(0) == 'x' ? r : (r & 0x3 | 0x8);
        return StringTools.hex(v);
    }).toLowerCase();
  }
  /**
    Best guess at platform filesystem seperator string
  **/
  static public function sep(_:Wildcard):String{
    #if sys
      var out = new haxe.io.Path(Sys.getCwd()).backslash ? "\\" : "/";
    #else
      var out = "/";
    #end
    return out;
  }
  /**
    make Some(Couple<L,R>) if Option<L> is defined;
  **/
  static public function lbump<L,R>(wildcard:Wildcard,tp:Couple<Option<L>,R>):Option<Couple<L,R>>{
    return tp.decouple(
      (lhs,rhs) -> lhs.fold(
        (l) -> Some(__.couple(l,rhs)),
        ()  -> None
      )
    );
  }
  /**
    make Some(Couple<L,R>) if Option<R> is defined;
  **/
  static public function rbump<L,R>(wildcard:Wildcard,tp:Couple<L,Option<R>>):Option<Couple<L,R>>{
    return tp.decouple(
      (lhs,rhs) -> rhs.fold(
        r   -> (Some(__.couple(lhs,r))),
        ()  -> None
      )
    );
  }
  static public function test(wildcard:Wildcard,arr:Iterable<haxe.unit.TestCase>){
    var runner = new haxe.unit.TestRunner();
    for(t in arr){
      runner.add(t);
    }
    runner.run();
  }
}