package stx.pico;

interface ReactApi{
  public function react():Void;
}
abstract class ReactCls implements ReactApi{
  abstract public function react():Void;
}
@:forward abstract React(ReactApi) from ReactApi to ReactApi{
  public function new(self) this = self;
  @:noUsing static public function lift(self:ReactApi):React return new React(self);

  public function prj():ReactApi return this;
  private var self(get,never):React;
  private function get_self():React return lift(this);
}
