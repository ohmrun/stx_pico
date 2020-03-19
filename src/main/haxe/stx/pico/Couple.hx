package stx.pico;

import stx.pico.couple.Constructor;

@:using(stx.pico.couple.Implementation)
@:callable abstract Couple<Ti,Tii>(CoupleDef<Ti,Tii>) from CoupleDef<Ti,Tii> to CoupleDef<Ti,Tii>{
  static public inline function _() return Constructor.ZERO;
  
}