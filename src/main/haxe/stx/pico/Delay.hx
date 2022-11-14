package stx.pico;

class Delay extends 
  #if flash
    stx.pico.delay.term.Flash
  #elseif js
    stx.pico.delay.term.Javascript
  #elseif target.threaded
    stx.pico.delay.term.Threaded
  #else
    stx.pico.delay.term.Ignore
  #end
{
  static public function comply(op,ms:Int):Delay{
    #if (debug && stx_log)
      __.log().trace('comply $ms');
    #end
    final delay = new stx.pico.Delay(op,ms);
          delay.start();
    return delay;
  }
}