package stx.pico;

/**
 * Class oriented value handler interface.
 * @see [suffixes](https://github.com/ohmrun/docs/blob/main/conventions.md#suffixes)
 * @see [naming](https://github.com/ohmrun/docs/blob/main/conventions.md#function-naming-conventions)
 */
interface SpendApi<P>{
  /**
   * Use value `p`
   */
  public function spend(p:P):Void;
  
  public function toSpend():Spend<P>;
}

/**
 * Class oriented value handler abstract
 * @see [suffixes](https://github.com/ohmrun/docs/blob/main/conventions.md#suffixes)
 * @see [naming](https://github.com/ohmrun/docs/blob/main/conventions.md#function-naming-conventions)
 */
abstract class SpendCls<P> implements SpendApi<P>{
  /**
   * Use value `p`
   */
  abstract public function spend(p:P):Void;
}
/**
 * 
 */
@:forward abstract Spend<P>(SpendApi<P>) from SpendApi<P> to SpendApi<P>{
  public function new(self) this = self;
  @:noUsing static public function lift<P>(self:SpendApi<P>):Spend<P> return new Spend<P>(self);

  /**
   * [Description]
   * @return SpendApi<P> return this
   */
  @:dox(hide)
  @:noCompletion
  public function prj():SpendApi<P> return this;
  private var self(get,never):Spend<P>;
  private function get_self():Spend<P> return lift(this);
}
