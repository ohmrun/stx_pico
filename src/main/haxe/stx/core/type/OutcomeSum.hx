package stx.core.type;

enum OutcomeSum<T,E>{
  Success(t:T);
  Failure(e:E);
}