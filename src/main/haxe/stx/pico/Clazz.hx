package stx.pico;

@:expose("stx.Clazz")
class Clazz{
  public function new(){}
  /**
   * Get the `Class` for `stx.pico.Clazz`
   * @return Class<Dynamic>
   */
  public final inline function definition():Class<Dynamic>{
    return Type.getClass(this);
  }
  /**
   * Get an identifier of this class
   * @return Identifier
   */
  public final inline function identifier():Identifier{
    return new Identifier(Type.getClassName(definition()));
  } 
}