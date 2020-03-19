package stx.pico.use;

class UsePico{
  static public function option<T>(wildcard:Wildcard,v:T):Option<T>{
    return switch(v){
      case null : None;
      default   : Some(v);
    }
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
  static public function test(wildcard:Wildcard,arr:Iterable<haxe.unit.TestCase>){
    var runner = new haxe.unit.TestRunner();
    for(t in arr){
      runner.add(t);
    }
    runner.run();
  }
}