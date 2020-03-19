package stx.pico;

enum Failure<T>{
  ERR(spec:FailCode);
  ERR_OF(v:T);
}