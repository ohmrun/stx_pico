package stx.pico.reduct.term;

class Anon<P,R,X> implements ReductApi<P,R,X>{
  private var delegate  : ReductDef<P,R,X>;
  
  public function new(delegate){
    this.delegate = delegate;
  }
  public function unit():X{
    return delegate.unit();
  }

  public function step(p:P,x:X):X{
    return delegate.step(p,x);
  }
  public function pure(x:X):R{
    return delegate.pure(x);
  }
  
  public function asReductDef():ReductDef<P,R,X>{
    return this;
  }
}