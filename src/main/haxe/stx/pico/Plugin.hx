package stx.pico;

import stx.pico.Macro;
//using Lambda;

#if macro
  import haxe.macro.Expr;
  import haxe.macro.Context;
  import haxe.macro.Type;
  import haxe.macro.Printer;

  using haxe.macro.ExprTools;
  using haxe.macro.TypedExprTools;
#end

class Plugin{
  static public macro function use(){
    var p = new Printer();
    #if stx_log
      new stx.Log().info("stx.pico.Plugin.use");
    #else
      trace("stx.pico.Plugin.use");
    #end
    final result = ["stx.pico.Option"].map(
      (x) -> Context.getType(x) 
    ).map(
      type -> {
        final a = switch(type){
          case TAbstract(t,args) :
            function is_nominal_type(type:Type){
              return switch(type){
                case TAbstract(_.get().name == t.get()  : true;
                default                                 : false;
              }
            }
            //trace(args);
            final fields = t.get().impl.get().statics.get().search(
              x -> x.name == "_"
            ).map(
              (x) -> Context.follow(x.type,false)
            ).flat_map(
              (x) -> {
                return switch(x){
                  case TAnonymous(t) :
                    switch(t.get().status){
                      case AClassStatics(ref) :
                        Some(ref.get().statics.get()); 
                      default : None;
                    }
                  default : None;
                }
              }
            ).defv([])
             .map_filter(
               field -> {
                 $type(field);
                // trace(p.printExpr(Context.getTypedExpr(field.expr())));
                 final return_type = switch(Context.follow(field.type)){
                  case TFun(_,ret)  : Option.make(ret);
                  default           : None;
                 }
                 final latch_type = switch(Context.follow(field.type)){
                  case TFun(arr,_)    : arr.head().map(x -> x.t);
                  default             : None;
                 }
                //  final is_fmap = switch([latch_type,return_type]){
                //    case 
                //  }
                 //trace('$latch_type -> $return_type');
                 //trace(return_type);
                 final tpath  = {
                    pack : ["stx.pico.js"],
                    name : t.get().name
                 }
                 final ct     = Context.toComplexType(type);
                 final cons   = macro function(data:$ct){ 
                   this.data=data;
                 }
                 final ntcp   = TPath(tpath);
                 final lift   = macro function lift(data:$ntcp){
                    return $i{type.toComplexType()}.lift(data);
                 }
                 //final next = macro function next(data:$ct,fn:)
                 //trace(wrap);
                 final decl   = {
                   pack : tpath.pack,
                   name : tpath.name,
                   pos  : Context.currentPos(),
                 }
                 return None;
               } 
             );
            //trace(fields);
            None; 
          default : None;
        }
        return {
          type : type
        }
      }
    );
    //trace(result);

    return macro {};
  }
  #if macro
    static public function delazy(type:Type){
      return switch()
    }
  #end
}