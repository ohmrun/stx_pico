package stx.pico.apply.term;

abstract class Delegate<T,P,R> extends ApplyCls<P,R>{
  public final delegate : T;
  public function new(delegate){
    this.delegate = delegate;
  }
}