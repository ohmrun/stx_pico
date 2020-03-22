package stx.core.pack.array;

class Destructure extends Clazz{
  public inline function random<T>(self:StdArray<T>):Null<T>{
    var len = self.length;
    var ind = Math.round( Math.random() * (len - 1));
    return self[ind];
  }
  public inline function bind_fold<R,A,B,M>(pure:B->M,init:B,bind:M->(B->M)->M,fold:A->B->B,self:StdArray<A>):M{
    return lfold(
      function(next:A,memo:M){
        return bind(memo,
          function(b:B){
            return pure(fold(next,b));
          }
        );
      },
      pure(init),
      self
    );
  }
  public inline function reduce<A,Z>(unit:Void->Z,pure:A->Z,plus:Z->Z->Z,self:StdArray<A>):Z{
    return self.lfold(
      function(next,memo){
        return plus(memo,pure(next));
      },
      unit()
    );
  }
  /**
		Call f on each element in a, returning a collection where f(e) = true.
	**/
  public inline function filter<T>(f: T -> Bool,self: StdArray<T>): Array<T> {
    var n: StdArray<T> = [];

    for (e in self)
      if (f(e)) n.push(e);

    return n;
  }
  public inline function map_filter<T,U>(f: T-> Option<U>,self:StdArray<T>) : Array<U>{
    return lfold(
      (next,memo:Array<U>) -> switch(f(next)){
        case Some(v)  : memo.snoc(v);
        default       : memo;
      },
      [],
      self
    );
  }
  /**
		Return true if length is greater than 1.
	**/
  public inline function is_defined<T>(a:Array<T>):Bool{
    return a.length > 0;
  }
  /**
		Applies function f to each element in a, returning the results.
	**/
  public inline function map<T, S>(f: T -> S,self: StdArray<T>): Array<S> {
    var n: StdArray<S> = [];

    for (e in self) n.push(f(e));

    return n;
  }
  public inline function mapi<T, S>(f: Int -> T -> S,self: StdArray<T>): Array<S> {
    var n: StdArray<S> = [];
    var e           = null;
    for (i in 0...self.length){
      e = self[i];
      n.push(f(i,e));
    };

    return n;
  }
  /**

    Using starting var z, run f on each element, storing the result, and passing that result
    into the next call:

        [1,2,3,4,5].lfold( function(next,memo) return init + v ));//(((((100 + 1) + 2) + 3) + 4) + 5)

	**/
  public inline function lfold<T, Z>(f: T -> Z -> Z,z:Z,self: StdArray<T>): Z {
    var r = z;

    for (e in self) { r = f(e,r); }

    return r;
  }
  /**
		set `v` at index `i` of `arr`.
	**/
  public inline function set<A>(i:Int,v:A,self:StdArray<A>):Array<A>{
    var arr0 : StdArray<A>     = self.copy();
    arr0[i]  = v;
    return arr0;
  }
  /**
		return element of `arr` at index `i`
	**/
  public inline function get<A>(i:Int,self:StdArray<A>):A{
    return self[i];
  }
  /**
    return element of `arr` at index `i`
  **/
  public inline function at<A>(i:Int,self:StdArray<A>):A{
    return self[i];
  }
  /**
		Performs a `lfold`, using the first value of `arr` as the `memo` value.
	**/
   public inline function lfold1<T>(mapper: T -> T -> T,self: StdArray<T>): Option<T> {
    var folded = self.head();
    var tail   = self.tail();
    return folded.map(
      (memo) -> {
        for(item in tail){
          memo = mapper(memo, item);
        };
        return memo;
      }
    );
  }
  @stx.doc("Produces a `Tuple2` containing two `Array`, the left being elements where `f(e) == true`, the rest in the right.")
  @params('The array to partition','A predicate')
  public inline function partition<T>(f: T -> Bool,self: StdArray<T>): { a : StdArray<T>, b :  StdArray<T> } {
    return self.lfold(function(next,memo:{ a : StdArray<T>, b : StdArray<T> } ) {
      if(f(next))
        memo.a.push(next);
      else
        memo.b.push(next);
      return memo;
    },{ a : [], b : [] });
  }

  /**

    Applies function f to each element in a, concating and returning the results.

	**/
  public inline function flat_map<T, S>(f:T->Iterable<S>,a:Array<T>):Array<S> {
    var n: StdArray<S> = [];

    for (e1 in a) {
      for (e2 in f(e1)) n.push(e2);
    }

    return n;
  }
  /**

    Counts some property of the elements of `arr` using a predicate. For the size of the Array @see `size()`

	**/
  public inline function count<T>(f: T -> Bool,self: StdArray<T>): Int {
    return self.lfold(function(b,a) {
      return a + (if (f(b)) 1 else 0);
    },0);
  }
  /**

    Takes an initial value which is passed to function `f` along with each element
    one by one, accumulating the results.
    f(next,memo)

	**/
  public inline function scanl<T>(f: T -> T -> T,init: T,self:StdArray<T>): Array<T> {
    var accum   = init;
    var result  = [init];

    for (e in self)
      result.push(f(e, accum));

    return result;
  }
  /**
		As `scanl` but from the end of the Array.
	**/
  public inline function rscan<T>(init: T, f: T -> T -> T,self:StdArray<T>): Array<T> {
    var a = self.snapshot();
    a.reverse();
    return scanl(f,init,a);
  }
  /**
		As scanl, but using the first element as the second parameter of `f`
	**/
  public inline function lscan1<T>(f: T -> T -> T,self:StdArray<T>): Array<T> {
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
		As scanr, but using the first element as the second parameter of `f`
	**/
  public inline function rscan1<T>(f: T -> T -> T,self:StdArray<T>): Array<T> {
    var a = self.snapshot();
    a.reverse();
    return lscan1(f,a);
  }
  /**
		Returns the Array cast as an Iterable.
	**/
  public inline function elements<T>(self: StdArray<T>): Iterable<T> {
    return self.snapshot();
  }
  /**
		concats the elements of `i` to `arr`
	**/
  public inline function concat<T>(i: Iterable<T>,self: StdArray<T>): Array<T> {
    var acc = self.snapshot();

    for (e in i)
      acc.push(e);

    return acc;
  }
  /**
		Produces `true` if the Array is empty, `false` otherwise
	**/
  public inline function containsValues<T>(self: StdArray<T>): Bool {
    return self.length > 0;
  }
  /**

    Produces an `Option.Some(element)` the first time the predicate returns `true`,
    `None` otherwise.

	**/
  public inline function search<T>(f: T -> Bool,self: StdArray<T>): Option<T>{
    return lfold(
      function(next,memo:Option<T>) {
        return switch (memo) {
            case None   : switch(next){
              case null : None;
              default   : Some(next).filter(f);
            }
            case Some(v): Some(v);
          }
      },
      None,
      self
    );
  }
  /**
		Returns an `Option.Some(index)` if an object reference is contained in `arr`, `None` otherwise.
	**/
  public inline function owns<T>(self: StdArray<T>, obj: T): Option<Int> {
   var index = self.indexOf(obj);
   return if (index == -1) None else Some(index);
  }

  /**
   Returns an Array that contains all elements from a which are not elements of b.
    If a contains duplicates, the resulting Array contains duplicates.
	**/
  public inline function difference<T>(eq:T->T->Bool, a:Array<T>, b:Array<T>){
    var res = [];
    for (e in a) {
      if (!any(function (x) return eq(x, e),b)) res.push(e);
    }
    return res;
  }
  public inline function shuffle <T>(self: StdArray<T>): Array<T>{
    var res = [];
    var cp = self.copy();
    while (cp.length > 0) {
      var randArray = Math.floor(Math.random()*cp.length);
      res.push(cp.splice(randArray,1)[0]);
    }
    return res;
  }
  /**

    Returns an Array that contains all elements from a which are also elements of b.
    If a contains duplicates, so will the result.

	**/
  public inline function union<T>(eq:T->T->Bool, a:Array<T>, b:Array<T>){
    var res = [];
    for(e in a){
      res.push(e);
    }
    for (e in b) {
      if (!any( function (x) return eq(x, e),res)) res.push(e);
    }
    return res;
  }

  public inline function unique<T>(eq:T->T->Bool,x:Array<T>):Array<T>{
    var eq : T -> T -> Bool = null;
    var r = [];
      for (e in x){
        var exists  = has(eq.bind(e),r);
        var val     = search(eq.bind(e),r);
        //trace('$exists $e in $r $val');
        if (!exists){
          r.push(e);
        } // you can inline exists yourself if you care much about speed. But then you should consider using hash tables or such

      }
    return r;
  }
  /**
		Produces `true` if the predicate returns `true` for all elements, `false` otherwise.
	**/
  public inline function all<T>(f: T -> Bool,self: StdArray<T>): Bool {
    return self.lfold(function(b,a) {
      return switch (a) {
        case true:  f(b);
        case false: false;
      }
    },true);
  }
  /**
		Produces `true` if the predicate returns `true` for *any* element, `false` otherwise.
	**/
  public inline function any<T>(f: T -> Bool,self: StdArray<T>): Bool {
    return self.lfold(function(b,a) {
      return switch (a) {
        case false: f(b);
        case true:  true;
      }
    },false);
  }
  /**
		Determines if a value is contained in `arr` using a predicate.
	**/
  public inline function has<T>(f: T -> Bool,self: StdArray<T>): Bool {
    return switch (search(f,self)) {
      case Some(_): true;
      case None:    false;
    }
  }
  /**
		Produces an Array with no duplicate elements. Equality of the elements is determined by `f`.
	**/
  public inline function nub<T>(f: T -> T -> Bool,self:StdArray<T>): Array<T> {
    return self.lfold(
      function(b: T,a: StdArray<T>): Array<T> {
        return if (has(f.bind(b), a)) {
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
		Intersects two Arrays, determining equality by `f`.
	**/
  public inline function intersect<T>(f: T -> T -> Bool, arr1: Array<T>, arr2: Array<T>): Array<T> {
    return arr1.lfold(
      (next:T, memo:Array<T>) -> switch(has(f.bind(next),arr2)){
        case true : memo.snoc(next);
        default   : memo;
      },
      []
    );
  }

  /**
		Produces the index of element `t`. For a function producing an `Option`, see `findArrayOf`.
	**/
  public inline function index<T>(self: StdArray<T>, t: T->Bool): Int {
    var index = 0;

    for (e in self) {
      if (t(e)) return index;

      ++index;
    }

    return -1;
  }
  /**
		As with `lfold` but working from the right hand side.
	**/
  public inline function rfold<T, Z>(f: T -> Z -> Z,z: Z,self: StdArray<T>): Z {
    var r = z;

    for (i in 0...self.length) {
      var e = self[self.length - 1 - i];

      r = f(e, r);
    }

    return r;
  }
  public inline function rfold1<T>(f:T->T->T,self:StdArray<T>){
    return self.reversed().lfold1(f);
  }
  /**
		Produces an `Array` of `Tuple2` where `Tuple2.t2(a[n],b[n]).`
	**/
  public inline function zip_with<A, B,C>(f:A -> B -> C,b: Array<B>,self: StdArray<A>): Array<C> {
    var next  = [];
    var lower = std.Std.int(Math.min(self.length,b.length));
    for(i in 0...lower){
      next.push(f(self[i],b[i]));
    }
    return next;
  }
  public inline function snoc<T>(t: T,self: StdArray<T>): Array<T> {
    var copy = snapshot(self);

    copy.push(t);

    return copy;
  }
  /**
		Adds a single elements to the beginning if the Array.
	**/
  public inline function cons<T>(t: T,self: StdArray<T>): Array<T> {
    var copy = snapshot(self);

    copy.unshift(t);

    return copy;
  }
  /**
		Produces the first element of `a` as an `Option`, `Option.None` if the `Array` is empty.
	**/
  public inline function head<T>(self: StdArray<T>): Option<T> {
    return if (self.length == 0) None; else Some(self[0]);
  }
  /**
		Produces the first element of `a` as an `Option`, `Option.None` if the `Array` is empty.
	**/
  public inline function tail<T>(self: StdArray<T>): Array<T> {
    return self.slice(1);
  }
  /**
		Produces the last element of Array `a`
	**/
  public inline function last<T>(self: StdArray<T>): Option<T> {
    var index = self.length - 1;
    return if(index<0){
      None;
    }else{
      var out = self[index];
      return out == null ? None : Some(out);
    }
  }
  /**
		Produces an `Array` from `a[0]` to `a[n]`
	**/
  public inline function ltaken<T>(n: Int,self: StdArray<T>): Array<T> {
    return self.slice(0, std.Std.int(Math.min(n,self.length)));
  }
  /**
	
  /**
		Produces an Array from `a[0]` while predicate `p` returns `true`
	**/
  public inline function whilst<T>(p: T -> Bool,self: StdArray<T>): Array<T> {
    var r = [];


    for (e in self) {
      if (p(e)) r.push(e); else break;
    }

    return r;
  }
  /**
		Produces an Array from `a[n]` to the last element of `a`.
	**/
  public inline function ldropn<T>(n: Int,self: StdArray<T>): Array<T> {
    return if (n >= self.length) [] else self.slice(n);
  }
  /**
		Produces an Array from `a[0]` to a[a.length-n].
	**/
  public inline function rdropn<T>(n: Int,self: StdArray<T>): Array<T> {
    return if (self!=null && n >= self.length) [] else self.splice(0,self.length - n);
  }
  /**
		Drops values from Array `a` while the predicate returns true.
	**/
  public inline function drop<T>(self: StdArray<T>, p: T -> Bool): Array<T> {
    var r = [].concat(self);

    for (e in self) {
      if (p(e)) r.shift(); else break;
    }

    return r;
  }
  /**
		Produces an Array with the elements in reversed order
	**/
  public inline function reversed<T>(self: StdArray<T>): Array<T> {
    return self.lfold(function(b,a:StdArray<T>) {
      a.unshift(b);

      return a;
    },[]);
  }
  /**
		Produces an Array of arrays of size `sizeSrc`
	**/
  public inline function chunk<T>(sizeSrc : StdArray<Int>,srcArr : StdArray<T>) : Array<Array<T>> return {
    var slices = [];
    var restArray = 0;
    for (size in sizeSrc) {
      var newRestArray = restArray + size;
      var slice = srcArr.slice(restArray, newRestArray);
      slices.push(slice);
      restArray = newRestArray;
    }
    slices;
  }
  /**
		Produces a map
	**/
  public inline function toMap<V>(self:StdArray<Void -> { a : String, b : V }>):Map<String,V>{
    var mp = new haxe.ds.StringMap();
    for(tp in self){
      var val = tp();
      mp.set(val.a,val.b);
    }
    return mp;
  }
  /**
		Pads out to len, ignores if len is less than Array length.
	**/
  public inline function pad<T>(len:Int,?val:T,self:StdArray<T>):Array<T>{
    var len0 = len - self.length;
    var arr0 = [];
    for (i in 0...len0){
      arr0.push(val);
    }
    return self.concat(arr0);
  }
  /**
		Fills `null` values in `arr` with `def`.
	**/
  public inline function fill<T>(def:T,self:StdArray<T>):Array<T>{
    return self.map(
      function(x){
        return x == null ? def : x;
      }
    );
  }
  public inline function and<A>(eq:A->A->Bool,arr1:Array<A>,arr0:Array<A>):Bool{
    return arr0.zip_with(arr1,(l,r)-> { a : l, b : r }).lfold(
      function(next:{ a : A, b : A },memo:Bool){
        return memo ? eq(next.a,next.b) && eq(next.a,next.b) : memo;
      },true
    );
  }
  public inline function rotate<A>(num:Int,arr0:Array<A>):Array<A>{
    num = num%arr0.length;
    var l = arr0.ltaken(num);
    var r = arr0.ldropn(num);
    return if(num < 0){
      concat(l,r);
    }else if(num > 1){
      concat(l,r);
    }else{
      arr0;
    }
  }
  /**
		Returns the size of a
	**/
  public inline function size<T>(self: StdArray<T>): Int {
    return self.length;
  }
  /**
		Returns a mutable copy of a.
	**/
  public inline function snapshot<T>(self: StdArray<T>): StdArray<T> {
    return [].concat(self);
  }
  /**
    from thx.core.pack
    It returns the cross product between two arrays.
    ```haxe
    var r = [1,2,3].cross([4,5,6]);
    trace(r); // [[1,4],[1,5],[1,6],[2,4],[2,5],[2,6],[3,4],[3,5],[3,6]]
    ```
  **/
  public inline function cross_with<T,Ti,Tii>(that : Array<Ti>,fn : T -> Ti -> Tii, self : Array<T>):Array<Tii> {
    var r = [];
    for (va in self)
      for (vb in that)
        r.push(fn(va, vb));
    return r;
  }
  // public inline function toLinkedList<T>(self:StdArray<T>){
  //   return rfold(
  //     Cons,
  //     Nil.ds(),
  //     arr
  //   ).ds();
  // }
}
