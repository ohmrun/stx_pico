package stx.pico;

import stx.pico.option.Constructor;

@:using(stx.pico.option.Implementation)
abstract Option<T>(OptionDef<T>) from OptionDef<T>{
  static public inline function _() return Constructor.ZERO;

  public function new(self) this = self;
  @:noUsing @:from static public function fromNullT<T>(v:Null<T>):Option<T> return _().make(v);

}