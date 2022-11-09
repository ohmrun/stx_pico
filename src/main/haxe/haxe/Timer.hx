package haxe;

import stx.pico.Delay;

class Timer{
  public final ms       : Int;
  public var stopped    : Bool;

  public function new(ms:Int){
    this.ms       = ms;
    this.stopped  = false;
    final self    = this;
    Delay.comply(
      function rec(){
        if(!stopped){
          run();
          Delay.comply(rec,ms);
        }
      },
      ms
    );
  }
  public dynamic function run():Void{
    
  }
  public function stop():Void{
    stopped = true;
  }
  static public function delay(f,ms){
    Delay.comply(f,ms);
  }
  
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  /**
		Measures the time it takes to execute `f`, in seconds with fractions.

		This is a convenience function for calculating the difference between
      `Timer.stamp()` before and after the invocation of `f`.

		The difference is passed as argument to `Log.trace()`, with `"s"` appended
		to denote the unit. The optional `pos` argument is passed through.

		If `f` is `null`, the result is unspecified.
	**/
	public static function measure<T>(f:Void->T, ?pos:PosInfos):T {
		var t0 = stamp();
		var r = f();
		Log.trace((stamp() - t0) + "s", pos);
		return r;
	}

	/**
		Returns a timestamp, in seconds with fractions.

		The value itself might differ depending on platforms, only differences
		between two values make sense.
	**/
	public static inline function stamp():Float {
		#if flash
		return flash.Lib.getTimer() / 1000;
		#elseif js
		#if nodejs
		var hrtime = js.Syntax.code('process.hrtime()'); // [seconds, remaining nanoseconds]
		return hrtime[0] + hrtime[1] / 1e9;
		#else
		return @:privateAccess HxOverrides.now() / 1000;
		#end
		#elseif cpp
		return untyped __global__.__time_stamp();
		#elseif python
		return Sys.cpuTime();
		#elseif sys
		return Sys.time();
		#else
		return 0;
		#end
	}
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
}