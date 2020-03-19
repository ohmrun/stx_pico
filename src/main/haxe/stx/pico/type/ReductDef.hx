package stx.pico.type;

typedef ReductDef<P,R,X> = {
  public function step(p:P,x:X):X;

  public function unit():X;
  public function pure(x:X):R;
}