package stx.pico.delay.term;

class Haxe{

  public var done(default,null)       : Bool;
  private var cancelled               : Bool;

  private final op                    : Void->Void;
  private final ms                    : Int;

  public function new(op,ms:Int){
    this.op       = op;
    this.ms       = ms;

    this.done      = false;
    this.cancelled = false; 
  }
  public function cancel(){
    #if (debug && stx_log) __.log().debug('cancel'); #end
    this.cancelled = true;
  }
  public function start(){
    #if (debug && stx_log)
      __.log().trace('start: $ms');
    #end
    final tstart = stamp();

    var event = null;
        event = haxe.MainLoop.add(
          () -> {
            #if (debug && stx_log)
            __.log().trace('done: $ms');
            #end
            if(cancelled){
              this.done = true;
              event.stop();
            }
            if(!done){
              if(stamp() > tstart + (ms/1000)){
                done = true;
                event.stop();
              }
            }
          }
        );
  }
  private function stamp(){
    return haxe.Timer.stamp();
  }
}