package stx.lift;

class IterableLift{
  @:noUsing static public function make<T>(self:Void->Iterator<T>):Iterable<T>{
    return {
      iterator : self
    };
  }
  static public function concat<T>(self:Iterable<T>,that:Iterable<T>):Iterable<T>{
    return make(
      () -> {
        var rest = false;
        final lhs = self.iterator();
        final rhs = that.iterator();
        return IteratorLift.make(
          () -> {
            return if(!rest){
              if(lhs.hasNext()){
                true;
              }else{
                rest = true;
                return rhs.hasNext();
              }
            }else{
              rhs.hasNext();
            }
          },
          () -> return if (!rest){
            lhs.next();
          }else{
            rhs.next();
          }
        );
      }
    );
  }
}