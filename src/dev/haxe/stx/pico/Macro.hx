package stx.pico;

#if macro
  import haxe.macro.Expr;
  import haxe.macro.Type;
#end
class Macro{
  #if macro
    static public function fold<Z>(expr:TypedExpr,fn:(next:TypedExpr,memo:Z)->Z,init:Z):Z{
      function rec(next:TypedExpr,memo:Z){
        final f = fn.bind(next);
        return switch(Option.make(next).map(x ->x.expr).defv(null)){
          case TConst(c)                      :
            f(memo);
          case TLocal(v)                      :
            f(memo);
          case TArray(e1, e2)                 :
            final a = rec(e1,memo);
            final b = rec(e2,a);
            f(b);  
          case TBinop(op, e1, e2)             :
            final a = rec(e1,memo);
            final b = rec(e2,a);
            f(b); 
          case TField(e, fa)                  :
            final a = rec(e,memo);
            f(a);
          case TTypeExpr(m)                   :
            f(memo);
          case TParenthesis(e)                :
            final a = rec(e, memo);
            f(a);
          case TObjectDecl(fields)            :
            final a = fields.map( x -> x.expr).lfold(rec,memo);
            f(a);
          case TArrayDecl(el)                 :
            final a = el.lfold(
              (memo,next) -> rec(memo,next),
              memo
            ); 
            f(a);
          case TCall(e, el)                   :
            final a = rec(e,memo);
            final b = el.lfold(rec,a);
            f(b);
          case TNew(c, params, el)            :
            final a = el.lfold(rec,memo);
            f(a);
          case TUnop(op, postFix, e)          :
            final a = rec(e,memo);
            f(a);
          case TFunction(tfunc)               :
            final a = tfunc.args.map(x -> x.value).lfold(rec,memo);
            final b = rec(tfunc.expr,a);
            f(b);
          case TVar(v, e)                  :
            final a = rec(e,memo);
            f(a);
          case TBlock(el)                     :
            final a = el.lfold(
              rec,
              memo
            );
            f(a);
          case TFor(v, e1, e2)                :
            final a = rec(e1,memo);
            final b = rec(e2,a);
            f(b);
          case TIf(econd, eif, eelse)         :
            final a = rec(econd,memo);
            final b = rec(eif,a);
            final c = rec(eelse,b);
            f(c);
          case TWhile(econd, e, normalWhile)  :
            final a = rec(econd,memo);
            final b = rec(e,a);
            f(b);
          case TSwitch(e, cases, edef)        :
            final a = rec(e,memo);
            final b = cases.lfold(
              (item,memo)  ->  {
                final c = item.values.lfold(
                  rec,memo
                );
                final d = rec(item.expr,c);
                return d;
              }
              ,a
            );
            final g = rec(edef,b);
            f(g);
          case TTry(e, catches)               :
            final a = rec(e,memo);
            final b = catches.map(x -> x.expr).lfold(rec,a);
            f(b);
          case TReturn(e)                     :
            final a = rec(e,memo);
            f(a);
          case TBreak                         :
            f(memo);
          case TContinue                      :
            f(memo);
          case TThrow(e)                      :
            final a = rec(e,memo);
            f(a);
          case TCast(e, m)                    :
            final a = rec(e,memo);
            f(a);
          case TMeta(m, e1)                   :
            final a = rec(e1,memo);
            f(a);
          case TEnumParameter(e1, ef, index)  :
            final a = rec(e1,memo);
            f(a);
          case TEnumIndex(e1)                 :
            final a = rec(e1,memo);
            f(a);
          case TIdent(s)                      :
            f(memo);
          case null                           : 
            memo;
        }
      }
      return rec(expr,init);
    }
  #end
}