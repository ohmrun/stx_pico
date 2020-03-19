package stx.pico.type;

enum OutcomeSum<T,E>{
  Success(t:T);
  Failure(e:E);
}