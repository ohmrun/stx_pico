package stx.core.pack;

@:expose("stx.Clazz")
class Clazz{
  public function new(){}
  public function definition():Class<Dynamic>{
    return Type.getClass(this);
  }
  public function identifier():String{
    return Type.getClassName(definition());
  }
}