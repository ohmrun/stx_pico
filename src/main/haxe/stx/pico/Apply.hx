package stx.pico;

interface ApplyApi<P,R>{
  public function apply(p:P):R;
  public function toApply():Apply<P,R>;
}
abstract class ApplyCls<P,R> implements ApplyApi<P,R>{
  abstract public function apply(p:P):R;
  public function toApply():Apply<P,R>{
    return this;
  }
}
@:forward abstract Apply<P,R>(ApplyApi<P,R>) from ApplyApi<P,R> to ApplyApi<P,R>{
  public function new(self) this = self;
  static public inline function lift<P,R>(self:ApplyApi<P,R>):Apply<P,R> return new Apply(self);

  @:noUsing static public inline function Anon<P,R>(self:P->R):Apply<P,R>{
    return lift(new stx.pico.apply.term.Anon(self));
  }
  public function prj():ApplyApi<P,R> return this;
  private var self(get,never):Apply<P,R>;
  private function get_self():Apply<P,R> return lift(this);
}
