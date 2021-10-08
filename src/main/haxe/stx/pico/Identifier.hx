package stx.pico;

abstract Identifier(String) to String{
  @:noUsing static public function lift(data:String){
    return new Identifier(data);
  }
  public function new(data) this = data;

  public var name(get,never):String;
  private function get_name():String{
    return this.split(".").last().defv("?");
  }
  public var pack(get,never):Array<String>;
  private function get_pack():Array<String>{
    return this.split(".").rdropn(1);
  }
  public function toString(){
    return this;
  }
  public function toArray(){
    var p = pack.copy();
        p.push(name);
    return p;
  }
}