package stx.core.pack;

import stx.core.pack.option.Constructor;

@:using(stx.core.pack.option.Implementation)
abstract Option<T>(OptionSum<T>) from OptionSum<T> to OptionSum<T>{
  static public inline function _() return Constructor.ZERO;

  public function new(self) this = self;
  @:noUsing @:from static public function fromNullT<T>(v:Null<T>):Option<T> return _().make(v);

}