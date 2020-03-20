package stx.pico.pack;

import stx.pico.pack.option.Constructor;

@:using(stx.pico.pack.option.Implementation)
abstract Option<T>(OptionSum<T>) from OptionSum<T> to OptionSum<T>{
  static public inline function _() return Constructor.ZERO;

  public function new(self) this = self;
  @:noUsing @:from static public function fromNullT<T>(v:Null<T>):Option<T> return _().make(v);

}