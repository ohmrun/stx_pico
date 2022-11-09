package stx.pico.delay.term;

#if stx_nano
  using stx.Nano;
#end
#if stx_log
  using stx.Log;
#end
import tink.core.Noise;

import tink.RunLoop;
#if target.threaded
  import sys.thread.Thread in HThread;


  typedef Milliseconds  = Int;
  typedef Seconds       = Float;

  class Threaded{
    static public var pool(get,null) : sys.thread.ElasticThreadPool;
    static public function get_pool(){
      return pool == null ? pool = new sys.thread.ElasticThreadPool(30) : pool; 
    }

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
      this.cancelled = true;
    }
    public function start(){
      #if (debug && stx_log)
        __.log().trace('start');
      #end
      final cb = RunLoop.current.bind(
        (cb) -> {
          #if (debug && stx_log)
          __.log().trace('done');
          #end
        }
      );
      run(cb);
    }
    private function run(cb){
      #if (debug && stx_log)
      __.log().trace('run');
      #end
      RunLoop.current.delegate(
        () -> {
          #if (debug && stx_log)
          __.log().trace('running');
          #end
          if(done){
            throw 'delay already called';     
          }else{
            #if (debug && stx_log)
            __.log().trace('waiting');
            #end
            Sys.sleep(ms / 1000);
            #if (debug && stx_log)
            __.log().trace('waited');
            #end
            done = true;
            if(!cancelled){
              trace('try');
              try{
                op();
              }catch(e){
                haxe.MainLoop.runInMainThread(
                  () -> throw(e)
                );
              }
            }
            #if (debug && stx_log)
            __.log().trace('ready');
            #end
            cb(Noise);
          }
          return Noise;
        },
        RunLoop.current.createSlave()
      );
    }
  }
#end