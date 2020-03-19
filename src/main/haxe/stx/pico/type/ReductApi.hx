package stx.pico.type;

interface ReductApi<P,R,X>{
  public function step(p:P,x:X):X;

  public function unit():X;
  public function pure(x:X):R;

  public function asReductDef():ReductDef<P,R,X>;
}