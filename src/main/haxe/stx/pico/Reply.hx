package stx.pico;

interface ReplyApi<R>{
  public function react():Void;
}
abstract class ReplyCls<R> implements ReplyApi<R>{
  abstract public function reply():Void;
}
@:forward abstract Reply<R>(ReplyApi<R>) from ReplyApi<R> to ReplyApi<R>{
  public function new(self) this = self;
  @:noUsing static public function lift<R>(self:ReplyApi<R>):Reply<R> return new Reply<R>(self);

  public function prj():ReplyApi<R> return this;
  private var self(get,never):Reply<R>;
  private function get_self():Reply<R> return lift(this);
}
