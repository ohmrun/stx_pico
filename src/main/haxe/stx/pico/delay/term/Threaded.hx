package stx.pico.delay.term;

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
      __.log().debug('cancel');
      this.cancelled = true;
    }
    public function start(){
      #if (debug && stx_log)
        __.log().trace('start: $ms');
      #end
      final cb = RunLoop.current.bind(
        (cb) -> {
          #if (debug && stx_log)
          __.log().trace('done: $ms');
          #end
        }
      );
      run(cb);
    }
    private function run(cb){
      var passed  = 0.0;
      var started = stamp();
      var steps   = 1;
      function is_ready(){
        final wanted_time   = (this.ms/1000) + started;
        final current_time  = stamp();
        __.log().trace('$current_time >= $wanted_time = ${current_time >= wanted_time}');
        return  current_time >= wanted_time;
      } 
      function next_wait(){
        final remaining = (ms/1000) - passed;
        return if(remaining < 0){
          0.1;
        }else{
          steps * 0.2 * 1.2;
        }
      }
      #if (debug && stx_log)
      __.log().trace('run: $ms');
      #end
      RunLoop.current.delegate(
        function step(){
          passed = stamp() - started;
          #if (debug && stx_log)
          __.log().trace('running: $ms');
          #end
          if(done){
            throw 'delay already called';     
          }else{
            #if (debug && stx_log)
            __.log().trace('waiting: $ms');
            #end
            
            final wait = next_wait();
            Sys.sleep(wait);
            steps++;

            #if (debug && stx_log)
            __.log().trace('waited: $wait');
            #end
            if(!cancelled){
              if(is_ready()){
                __.log().trace('try: $ms');
                try{
                  done = true;
                  #if (debug && stx_log)
                  __.log().trace('ready');
                  #end
                  op();
                  cb(Noise);
                }catch(e){
                  haxe.MainLoop.runInMainThread(
                    () -> throw(e)
                  );
                }
              }else{
                RunLoop.current.delegate(step,RunLoop.current.createSlave());
              }
            }else{
              cb(Noise);
            }
          }
          return Noise;
        },
        RunLoop.current.createSlave()
      );
    }
    private function stamp(){
      return haxe.Timer.stamp();
    }
  }
#end