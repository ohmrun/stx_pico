package stx.pico.use;

class UseCouple{    
  static public function couple<Ti,Tii>(wildcard:Wildcard,tI:Ti,tII:Tii):Couple<Ti,Tii>{
    return (fn:Ti->Tii->Void) -> {
      fn(tI,tII);
    }
  }
  static public function toCouple<Ti,Tii>(self:CoupleDef<Ti,Tii>):Couple<Ti,Tii>{
    return self;
  }
}