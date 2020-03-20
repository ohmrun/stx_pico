package stx.pico.pack.option;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();
  /**
		Produces Option.Some(t) if `t` is not null, Option.None otherwise.
	**/
  public function make<T>(t: T): Option<T> {
    return if (t == null) None; else Some(t);
  }
    /**
		Produces an Option where `o1` may contain another Option.
	**/
  public function flatten<T>(o1: Option<Option<T>>): Option<T> {
    return switch (o1.prj()) {
      case None       : None;
      case Some(o2)   : o2;
    }
  }
}