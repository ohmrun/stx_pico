package stx.lift;

class IteratorLift{
  @:noUsing static public function make<T>(hasNext:Void->Bool,next:Void->T):Iterator<T>{
    return {
      hasNext : hasNext,
      next    : next
    };
  }
}