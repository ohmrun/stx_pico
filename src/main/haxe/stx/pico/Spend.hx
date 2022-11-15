package stx.pico;

interface SpendApi<P>{
  public function react():Void;
}
abstract class SpendCls<P> implements SpendApi<P>{
  abstract public function spend(p:P):Void;
}
@:forward abstract Spend<P>(SpendApi<P>) from SpendApi<P> to SpendApi<P>{
  public function new(self) this = self;
  @:noUsing static public function lift<P>(self:SpendApi<P>):Spend<P> return new Spend<P>(self);

  public function prj():SpendApi<P> return this;
  private var self(get,never):Spend<P>;
  private function get_self():Spend<P> return lift(this);
}
