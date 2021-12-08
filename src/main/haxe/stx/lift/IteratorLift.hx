package stx.lift;

class IteratorLift{
  static public function make<T>(hasNext:Void->Bool,next:Void->T):Iterator<T>{
    return {
      hasNext : hasNext,
      next    : next
    };
  }
}