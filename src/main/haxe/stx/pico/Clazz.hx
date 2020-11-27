package stx.pico;

@:expose("stx.Clazz")
class Clazz{
  public function new(){}
  public final inline function definition():Class<Dynamic>{
    return Type.getClass(this);
  }
  public final inline function identifier():Identifier{
    return new Identifier(Type.getClassName(definition()));
  }
}