package stx.lift;

import haxe.Constraints.IMap;

using stx.Pico;

/**
 * Static extensions for Arrays
 */
class ArrayLift{
  /**
    * Produces an Array from an Array of Arrays.
  **/
  static public function flatten<T>(arrs: Array<Array<T>>): Array<T> {
    var res : StdArray<T> = [];
    for (arr in arrs) {
      for (e in arr) {
        res.push(e);
      }
    }
    return res;
  }
  /**
    Weaves an `Array` of arrays so that `[ array0[0] , array1[0] ... arrayn[0] , array0[1], array1[1] ... ]`
    Continues to operate to the length of the shortest array, and drops the rest of the elements.
  **/
  static public function interleave<T>(alls: StdArray<StdArray<T>>): Array<T> {
    var res = [];
    if (alls.length > 0) {
      var length = {
        var minLength = alls[0].length;
        for (e in alls)
          minLength = std.Std.int(Math.min(minLength, e.length));
        minLength;
      }
      var i = 0;
      while (i < length) {
        for (arr in alls)
          res.push(arr[i]);
        i++;
      }
    }
    return res;
  }
  /**
		* Return true if the length of `self` is greater than 0.
	**/
  static public inline function is_defined<T>(self:StdArray<T>):Bool{
    return self.length > 0;
  }
  /**
   * Return an `Array` including `t:T` at the beginning. 
   * @param self 
   * @param t
   * @return Option<T>
   */
  static public function cons<T>(self:StdArray<T>,t:T):Array<T>{
    var copy = copy(self);  
        copy.unshift(t);
      return copy;
  }
  /**
   * Return an `Array` including `t:T` at the end. 
   * @param self 
   * @param t 
   * @return Array<T>
   */
  static public function snoc<T>(self:StdArray<T>,t:T):Array<T>{
    var copy = copy(self);
        copy.push(t);
    return copy;
  }
  /**
		Produces an `Array` wherein the value at `self[i]` is  `t`.
	**/
  static public inline function set<T>(self:StdArray<T>,i:Int,v:T):Array<T>{
    var arr0 : StdArray<T>     = self.copy();
    arr0[i]  = v;
    return arr0;
  }
  /**
		* Produces the element of `self` at index `i`
	**/
  static public inline function get<T>(self:StdArray<T>,i:Int):T{
    return self[i];
  }
  /**
   * Produces the first element of `self` as an `Option`, `Option.None` if the `Array` is empty or the value is null.
   * @param self 
   */
  static public function head<T>(self:StdArray<T>):Option<T>{
    return self.length == 0 ? None : self[0] == null ? None : Some(self[0]);
  }
  /**
   * Produces an `Array` of all elements after the first.
   * @param self
   * @return array
   */
  static public function tail<T>(self:StdArray<T>):Array<T>{
    return self.slice(1);
  }
  /**
   * Produces the last element of `self` if defined.
   * @param self
   * @return option
  **/  
  static public function last<T>(self:StdArray<T>):Option<T>{
    var v   = self[self.length > 0 ? self.length - 1 : 0];
    return v == null ? None : Some(v);
  }

  /**
   * Produces a seperate, shallow copy of `self`.
   * @param self
   * @return array
  **/
  static public function copy<T>(self:StdArray<T>):Array<T>{
    return [].concat(self);
  }
  /**
   * Produces an `Array` containing the contents of `self` followed by the contents of `that`.
  **/
  static public function concat<T>(self:StdArray<T>,that:Iterable<T>):Array<T>{
    var acc = copy(self);

    for (e in self)
      acc.push(e);

    return acc;
  }
  /**
   * Achieves a flat_map by passing the `bind` function as a parameter.
  **/
  static public function bind_fold<T,Ti,TT>(self:StdArray<T>,pure:Ti->TT,init:Ti,bind:TT->(Ti->TT)->TT,fold:T->Ti->Ti):TT{
    return lfold(
      self,
      function(next:T,memo:TT):TT{
        return bind(memo,
          function(b:Ti):TT{
            return pure(fold(next,b));
          }
        );
      },
      pure(init)
    );
  }
  /**
   * Folds `self` into `TT` by first constructing a `pure` value from each element.
  **/
  static public function reduce<T,TT>(self:StdArray<T>,unit:Void->TT,pure:T->TT,plus:TT->TT->TT):TT{
    return self.lfold(
      function(next,memo){
        return plus(memo,pure(next));
      },
      unit()
    );
  }
  /**
	 * Produces an `Array` containing the results of `f` applied to `self`.
 	**/
  static public function map<T,TT>(self:StdArray<T>,fn:T->TT):Array<TT>{
    var n: StdArray<TT> = [];

    for (e in self) n.push(fn(e));

    return n;
  }
  /**
   * Applies function `f` to each element in `self`, passing the index in the left hand parameter, 
   * returning an `Array`.
	**/
  static public function imap<T,TT>(self:StdArray<T>,fn:Int->T->TT):Array<TT>{
    var n: StdArray<TT> = [];
    var e           = null;
    for (i in 0...self.length){
      e = self[i];
      n.push(fn(i,e));
    };

    return n;
  }
  /**
   * Applies function `f` to each element in `self`, concatenating and returning the results.
	**/
   static public function flat_map<T,TT>(self:StdArray<T>,fn:T->Iterable<TT>):Array<TT>{
    var n: StdArray<TT> = [];

    for (e1 in self) {
      for (e2 in fn(e1)) n.push(e2);
    }

    return n;
  }
  /**
   * Using starting var `tt`, run `f` on each element, storing the result, and passing that result
   * into the next call:
   * ```
   * [1,2,3,4,5].lfold( function(next,memo) return init + v, 100 ));//(((((100 + 1) + 2) + 3) + 4) + 5)
   * ```
	**/
  static public function lfold<T,TT>(self:StdArray<T>,fn:T->TT->TT,memo:TT):TT{
    var r = memo;

    for (e in self) { r = fn(e,r); }

    return r;
  }
  /**
	 * Performs a `lfold`, using the first value of `arr` as the `memo` value.
	**/
  static public function lfold1<T>(self:StdArray<T>,fn:T->T->T):Option<T>{
    var folded = self.head();
    var tail   = self.tail();
    return folded.map(
      (memo) -> {
        for(item in tail){
          memo = fn(memo, item);
        };
        return memo;
      }
    );
  }
  /**
	 * As with `lfold` but working from the right hand side.
	**/
  static public function rfold<T,TT>(self:StdArray<T>,fn:T->TT->TT,z:TT):TT {
    var r = z;
    for (i in 0...self.length) {
      var e = self[self.length - 1 - i];

      r = fn(e, r);
    }
    return r;
  }
  static public function rfold1<T>(self:StdArray<T>,fn:T->T->T):Option<T>{
    return lfold1(reversed(self),fn);
  }
  /**
   * Takes an initial value which is passed to function `f` along with each element
   * one by one, accumulating the results. `f(next,memo)`
	**/
  static public function lscan<T>(self:StdArray<T>,f: T -> T -> T,init: T): Array<T> {
    var accum   = init;
    var result  = [init];

    for (e in self)
      result.push(f(e, accum));

    return result;
  }
  /**
	 * As `scanl`, but using the first element as the second parameter of `f`
	**/
  static public function lscan1<T>(self:StdArray<T>,f: T -> T -> T): Array<T> {
    var result = [];
    if(0 == self.length)
      return result;
    var accum = self[0];
    result.push(accum);
    for(i in 1...self.length)
      result.push(f(self[i], accum));

    return result;
  }
  /**
	 * As `lscan` but from the end of the `Array`.
	**/
  static public function rscan<T>(self:StdArray<T>,init: T, f: T -> T -> T): Array<T> {
    var a = self.copy();
        a.reverse();
    return lscan(a,f,init);
  }
  /**
	 * As `rscan`, but using the first element as the second parameter of `f`
	**/
  static public function rscan1<T>(self:StdArray<T>,f: T -> T -> T): Array<T> {
    var a = self.copy();
    a.reverse();
    return lscan1(a,f);
  }
  /**
	 * Call `f` on each element in `self`, returning an Array where `f(e) = true`.
	**/
  static public function filter<T>(self:StdArray<T>,fn:T->Bool):Array<T>{
    var n: StdArray<T> = [];

    for (e in self)
      if (fn(e)) n.push(e);

    return n;
  }
  /**
	 * Call `f` on each element in `self`, returning an `Array` where the result is `Some(tt:TT)`
	**/
  static public function map_filter<T,TT>(self:StdArray<T>,fn:T->Option<TT>):Array<TT>{
    return lfold(
      self,
      (next,memo:Array<TT>) -> switch(fn(next)){
        case Some(v)  : memo.snoc(v);
        default       : memo;
      },
      []
    );
  }
  /**
	 * As with `filter`, but produces nothing more after the predicate `p` first returns `false`.
	**/
  static public function whilst<T>(self:StdArray<T>,fn:T->Bool):Array<T> {
    var r = [];

    for (e in self) {
      if (fn(e)) r.push(e); else break;
    }

    return r;
  }
  /**
   * Alias of `Array.#slice`
   * @param self 
   * @param p 
   * @return Array<T>
   */
  static public function range<T>(self:StdArray<T>,l:Int,?r:Int):Array<T>{
    return self.slice(l,r);
  }
  /**
	 * Produces an `Array` from `self[0]` to `self[n]`
	**/
  static public function ltaken<T>(self:StdArray<T>,n):Array<T>{
    return self.slice(0, std.Std.int(Math.min(n,self.length)));
  }
  /**
	 * Produces an Array from `self[n]` up to and including the last element.
	**/
  static public function ldropn<T>(self:StdArray<T>,n):Array<T>{  
    return if (n >= self.length) [] else self.slice(n);
  } 
                                    
  /**
	 * Produces an `Array` from `self[0]` to `self[a.length-n]`.
	**/
  static public function rdropn<T>(self:StdArray<T>,n:Int):Array<T> {
    return if (self!=null && n >= self.length) [] else self.splice(0,self.length - n);
  }
  /**
	* Drops values from `self` while the predicate returns `true`.
	**/
  static public inline function ldrop<T>(self: StdArray<T>, p: T -> Bool): Array<T> {
    var r = [].concat(self);

    for (e in self) {
      if (p(e)) r.shift(); else break;
    }

    return r;
  }
  /**
    * Produces an `Option.Some(element)` the first time the predicate returns `true`,
    * `None` otherwise.
	**/
  static public function search<T>(self:StdArray<T>,fn:T->Bool):Option<T>{
    var out = None;
    for(el in self){
      if(fn(el)){
        out = Some(el);
        break;
      }
    }
    return out;
  }
  /**
	 * Produces `true` if the predicate returns `true` for all elements, `false` otherwise.
	**/
  static public function all<T>(self:StdArray<T>,fn:T->Bool):Bool{
    return self.lfold(function(b,a) {
      return switch (a) {
        case true:  fn(b);
        case false: false;
      }
    },true);
  }
  /**
	 * Produces `true` if the predicate returns `true` for *any* element, `false` otherwise.
	**/
  static public function any<T>(self:StdArray<T>,fn:T->Bool): Bool {
    return self.lfold(function(b,a) {
      return switch (a) {
        case false: fn(b);
        case true:  true;
      }
    },false);
  }

  /**
	 * Produces an `Array` of `f(l_element,r_element)`. Goes to the shorter of the two `Array`s.
	**/
  static public function zip_with<T,Ti,TT>(self:StdArray<T>,that:StdArray<Ti>,fn:T->Ti->TT):Array<TT> {
    var next  = [];
    var lower = std.Std.int(Math.min(self.length,that.length));
    for(i in 0...lower){
      next.push(fn(self[i],that[i]));
    }
    return next;
  } 
  /**
    * from thx.core
    * It returns the cross product between two arrays.
    * ```haxe
    * var r = [1,2,3].cross_with([4,5,6],(lhs,rhs) -> [lhs,rhs]);
    * trace(r); // [[1,4],[1,5],[1,6],[2,4],[2,5],[2,6],[3,4],[3,5],[3,6]]
    * ```
  **/
  static public function cross_with<T,Ti,TT>(self : Array<T>, that : Array<Ti>,fn : T -> Ti -> TT):Array<TT> {
    var r = [];
    for (va in self)
      for (vb in that)
        r.push(fn(va, vb));
    return r;
  }
  /**
   * Produces an Array that contains all elements from `self` which are not elements of `that`, using `f`.
   * If `self` contains duplicates, the resulting `Array` contains duplicates.
	**/
  static public function difference_with<T>(self:Array<T>, that:Array<T>,eq:T->T->Bool){
    var res = [];
    for (e in self) {
      if (!any(that,function (x) return eq(x, e))) res.push(e);
    }
    return res;
  }
  /**
   * Produces an `Array` that contains all elements from `self` which are also elements of `that`.
   * If `self` contains duplicates, so will the result.
	**/
  static public inline function union_with<T>(self:Array<T>, that:Array<T>,eq:T->T->Bool){
    var res = [];
    for(e in self){
      res.push(e);
    }
    for (e in that) {
      if (!any(res,function (x) return eq(x, e))) res.push(e);
    }
    return res;
  }
  static public function unique_with<T>(self:StdArray<T>,eq:T->T->Bool):Array<T>{
    var r = [];
      for (e in self){
        var exists  = any(r,eq.bind(e));
        var val     = search(r,eq.bind(e));
        //trace('$exists $e in $r $val');
        if (!exists){
          r.push(e);
        } 
      }
    return r;
  }
  /**
   * Produces an `Array` with no duplicate elements as determined by `f`. 
	**/
  static public function nub_with<T>(self:StdArray<T>,f: T -> T -> Bool): Array<T> {
    return self.lfold(
      function(b: T,a: StdArray<T>): Array<T> {
        return if (any(a,f.bind(b))) {
          a;
        }
        else {
          a.snoc(b);
        }
      },
      []
    );
  }
  /**
	 * Intersects two `Array`s, determining equality by `f`.
	**/
  static public inline function intersect_with<T>(self: StdArray<T>, that: StdArray<T>,f: T -> T -> Bool): Array<T> {
    return self.lfold(
      (next:T, memo:Array<T>) -> switch(any(that,f.bind(next))){
        case true : memo.snoc(next);
        default   : memo;
      },
      []
    );
  }
  /**
		* Produces an `Array` with the elements in reversed order.
	**/
  static public inline function reversed<T>(self: StdArray<T>): Array<T> {
    return self.lfold(function(b,a:StdArray<T>) {
      a.unshift(b);

      return a;
    },[]);
  }
  /**
   * Counts some property of the elements of `self` using predicate `p`. 
   * For the length of the Array @see `size()`.
	**/
  static public inline function count<T>(self: StdArray<T>, f: T -> Bool): Int {
    return self.lfold(function(b,a) {
      return a + (if (f(b)) 1 else 0);
    },0);
  }
  /**
	 * Returns the number of elements in `self`
	**/
  static public inline function size<T>(self: StdArray<T>): Int {
    return self.length;
  }

  /**
	 * Produces the index of element `t`. For a function producing an `Option`, see `findArrayOf`.
	**/
  static public inline function index_of<T>(self: StdArray<T>, t: T->Bool): Int {
    var index = 0;
    var ok    = false;

    for (e in self) {
      if (t(e)){
        ok = true;
        break;
      }

      ++index;
    }

    return ok ? index : -1;
  }
  /**
	 * Determines if a value is contained in `self` by identity.
	**/
  static public inline function has<T>(self: StdArray<T>,obj:T): Option<Int> {
    var index = self.indexOf(obj);
    return if (index == -1) None else Some(index);
  }
  /**
   * Produces a tuple containing two `Array`s, `a` being elements where `f(e) == true`, and `b`, the rest.
   * @param self The array to partition
   * @param f A predicate
   * @param into
  **/
  static public inline function partition<T>(self: StdArray<T>,f: T -> Bool): { a : StdArray<T>, b :  StdArray<T> } {
    return self.lfold(function(next,memo:{ a : StdArray<T>, b : StdArray<T> } ) {
      if(f(next))
        memo.a.push(next);
      else
        memo.b.push(next);
      return memo;
    },{ a : [], b : [] });
  }
  /**
	 * Produces an `Array` of `Array`s of size `size`.
	**/
  static public function chunk<T>(self : StdArray<T>, size : StdArray<Int>) : Array<Array<T>> return {
    var slices = [];
    var rest = 0;
    for (n in size) {
      var next  = rest + n;
      var slice = self.slice(rest, next);
      slices.push(slice);
      rest = next;
    }
    slices;
  }
  /**
	 * Pads out to `len` with `val`, ignores if `len` is less than `Array.size()`.
	**/
  static public function pad<T>(self:StdArray<T>,len:Int,?val:T):Array<T>{
    var len0 = len - self.length;
    var arr0 = [];
    for (i in 0...len0){
      arr0.push(val);
    }
    return self.concat(arr0);
  }
  /**
	 * Fills `null` values in `self` with `def`.
	**/
  static public inline function fill<T>(self:StdArray<T>,def:T):Array<T>{
    return self.map(
      function(x){
        return x == null ? def : x;
      }
    );
  }
  static public function toIterable<T>(self:StdArray<T>):Iterable<T>                                    return self;
  /**
	 * Produces a `haxe.ds.Map` 
	**/
  static public inline function toMap<T>(self:StdArray<Void -> { a : String, b : T }>):Map<String,T>{
    var mp = new haxe.ds.StringMap();
    for(tp in self){
      var val = tp();
      mp.set(val.a,val.b);
    }
    return mp;
  }
  static public function random<T>(self:StdArray<T>):Null<T>{
    var len = self.length;
    var ind = Math.round( Math.random() * (len - 1));
    return self[ind];
  }
  static public function shuffle<T>(self: StdArray<T>): Array<T>{
    var res = [];
    var cp = self.copy();
    while (cp.length > 0) {
      var randArray = Math.floor(Math.random()*cp.length);
      res.push(cp.splice(randArray,1)[0]);
    }
    return res;
  }  
  static public function and_with<T>(self:Array<T>,that:Array<T>,eq:T->T->Bool):Bool{
    return self.zip_with(that,(l,r)-> { a : l, b : r }).lfold(
      function(next:{ a : T, b : T },memo:Bool){
        return memo ? eq(next.a,next.b) && eq(next.a,next.b) : memo;
      },true
    );
  }
  static public function rotate<T>(self:Array<T>,num:Int):Array<T>{
    num = num%self.length;
    var l = self.ltaken(num);
    var r = self.ldropn(num);
    return if(num < 0){
      concat(l,r);
    }else if(num > 1){
      concat(l,r);
    }else{
      self;
    }
  }
  // static public function toLinkedList<T>(self:StdArray<T>){
  //   return rfold(
  //     Cons,
  //     Nil.ds(),
  //     arr
  //   ).ds();
  // }
  static public function iterator<T>(self:StdArray<T>):Iterator<T>                                      return self.iterator();
  static public function elide<T>(self:StdArray<T>):Array<Dynamic>                                      return map(self,(v) -> (v:Dynamic));
  static public function prj<T>(self:StdArray<T>):StdArray<T>                                           return self;
}