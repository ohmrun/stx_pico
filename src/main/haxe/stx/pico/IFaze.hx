package stx.pico;

interface IFaze{
  public function definition():Class<Dynamic>;
  public function identifier():Identifier;
}