package stx.core.pack;

import haxe.Constraints.IMap;

@:expose("stx.Array")
@:using(stx.core.pack.array.Implementation)
@:forward abstract Array<T>(std.Array<T>) from std.Array<T> to std.Array<T>{
  static public var ZERO(default,null) : Array<Dynamic> = [];

  public function new(self) this = self;

  @:arrayAccess public function get(v:Int) return this[v];
}
