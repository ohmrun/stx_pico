package stx.pico;

abstract Identifier(String) to String{
  public function new(self) this = self;

  public var name(get,never):String;
  private function get_name():String{
    return this.split(".").last().defv("?");
  }
  public var pack(get,never):Array<String>;
  private function get_pack():Array<String>{
    return this.split(".").rdropn(1);
  }
  public function toIdentDef():IdentDef{
    var n = name;
    var p = pack;
    return {
      name : n,
      pack : p
    }
  }
}