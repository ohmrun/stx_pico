package stx.pico;

/**
 * cribbed wholesale
 */
enum abstract Nada(Int) {
 var Nada = 0;
 @:from static function fromDynamic(_:Dynamic):Nada return Nada;
}