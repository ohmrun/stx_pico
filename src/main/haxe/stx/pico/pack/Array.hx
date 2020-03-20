package stx.pico.pack;

import haxe.Constraints.IMap;

@:using(stx.pico.pack.array.Implementation)
@:forward(iterator,join,length)abstract Array<T>(std.Array<T>) from std.Array<T> to std.Array<T>{
  static public var ZERO(default,null) : Array<Dynamic> = [];

  public function new(self) this = self;

  @:arrayAccess public function get(v:Int) return this[v];
}
