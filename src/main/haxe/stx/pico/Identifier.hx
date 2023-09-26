package stx.pico;

import haxe.io.Path;

abstract Identifier(String) to String{
  @:noUsing static public function fromPath(path:haxe.io.Path):Identifier{
    final dir   = Path.directory(path.toString());
    final ext   = path.ext;
    final file  = path.file;
    final name  = ext == null ? file : '${file}.${ext}'; 
    final sep   = path.backslash ? "\\" : "/";
    final data  = dir.split(sep);
          data.push(name);
    return lift(data.join("."));
  }
  @:noUsing static public function lift(data:String){
    return new Identifier(data);
  }
  @:noUsing static public function pure(self:String){
    return new Identifier(self);
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