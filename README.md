# stx.Pico

Cravenly unobtrusive force multiplier library for Haxe. i.e My version of the stuff that everyone has a version of. Should play nice with everyone, tell me otherwise and I'll fix it.


`using stx.Pico` pulls in...

```haxe
  Option<O>
  Either<L,R>
  Outcome<S,F>
  
  ArrayLift
```


## Option

### Usage

```haxe

enum Option<T>{
  Some(t:T);
  None;
}
//-------------
var a = Some(1);
var b = a.map(
  (x) -> x + 1 // if defined, add one
).flat_map(
  (x) -> None // if defined, return None
).defv(9);//default value, results in 9
```
  

```haxe
@:noUsing static public function make<T>(t: T): Option<T> 
```

Produces `Some(t)` if `t` is not null, `None` otherwise.


```haxe
@:noUsing @:from static public function fromNullT<T>(v:Null<T>):Option<T>
```


```haxe
static public function flatten<T>(self: Option<Option<T>>): Option<T>
```

Produces an Option where `self` may contain another Option.
  
## OptionLift
  These are automatically available to all `haxe.ds.Option`, but are available as static functions via `Option._`



```haxe
static public function fold<T,TT>(self:OptionSum<T>,ok:T->TT,no:Void->TT):TT
```

supply handlers for the cases and retrieve one ore other values.


```haxe
static public function map<T, TT>(self: OptionSum<T>,f: T -> TT):Option<TT>

Performs `f` on the contents of `self` if `self != None`


```haxe
static public function flat_map<T, TT>(self: OptionSum<T>,f: T -> Option<TT>): Option<TT>
```

Produces the `Option` result of `f` which takes the contents of `self` as a parameter
  

```haxe
static public function or<T>(self: OptionSum<T>, thunk: Void -> OptionSum<T>):Option<T>
```

Produces `self` if it is `Some(x)`, the result of `thunk` otherwise.


```haxe
static public function filter<T>(self:OptionSum<T>,fn:T->Bool):Option<T>
```

returns `None` if filter returns `false`, `Some(t:T)` otherwise.
  


```haxe
static public function def<T>(self: OptionSum<T>, thunk: Void->T): T
```

Produces the value of `self` if not `None`, the result of `thunk` otherwise.
  

```haxe
static public function defv<T>(self:OptionSum<T>,v:T):T
```

Returns the inner value of `self` or the value `v` if `self ` is `None`


```haxe
static public function is_defined<T>(self:OptionSum<T>)
```

returns `true` if self is `Some(v)`, `false` otherwise.
  


```haxe
static public function iterator<T>(self:OptionSum<T>):Iterator<T>{
```

returns an `Iterator`. makes `Option` avaliable for use in array comprehensions.



```haxe
static public function merge<T>(self:OptionSum<T>,that:OptionSum<T>,fn : T -> T -> T):OptionSum<T>
```

Produces one or other value if only one is defined, or calls `fn` on the two and returns the result



```haxe
static public function toArray<T>(self: OptionSum<T>): Array<T>
```
Produces an `Array` of length 0 if `self` is None, length 1 otherwise.



## Either

```haxe
enum Either<L,R>{
  Left(l:L);
  Right(r:R);
}
```

```haxe
static public function fold<Ti,Tii,R>(self:EitherSum<Ti,Tii>,lhs:Ti->R,rhs:Tii->R):R{
```
Applies `lhs` if the value is `Left` and `rhs` if the value is `Right`, returning the result.


```haxe  
static public function map<Ti,Tii,R>(self:Either<Ti,Tii>,fn:Tii->R):Either<Ti,R>
```
applies `fn` if the value is `Right`, producing `Right(R)`


```haxe
static public function flat_map<Ti,Tii,R>(self:Either<Ti,Tii>,fn:Tii->Either<Ti,R>:Either<Ti,R>
```

`map`s and then `flatten` the `Right` value if it exists, or pass the `Left` untouched.
  

```haxe
static public function flip<Ti,Tii>(self:Either<Ti,Tii>):Either<Tii,Ti>
```
makes a `Left` a `Right` and vice-versa.


## Outcome

```
enum Outcome<T,E>{
  Success(t:T);
  Failure(e:E);
}
```

```haxe
static public function map<T,E,TT>(self:OutcomeSum<T,E>,fn:T->TT):Outcome<TT,E>
```
applies function `fn` if outcome is `Success`, or passes error `E`


```haxe
static public function flat_map<T,E,TT>(self:OutcomeSum<T,E>,fn:T->OutcomeSum<TT,E>
:Outcome<TT,E>
```

applies function `fn`, allowing the change from `Success` to `Failure` if `self` is `Success`


```haxe
static public function fold<T,E,TT>(self:OutcomeSum<T,E>,fn:T->TT,er:E->TT):TT
```
supply handlers and receive one or other of the values, depending on `self`


```haxe
static public function fudge<T,E>(self:OutcomeSum<T,E>):T
  
```
return the inner value or throw `E` if `self` is `Failure`
  


```haxe
static public function elide<T,E>(self:OutcomeSum<T,E>):Outcome<Dynamic,E>
```
untype the `T` type


## Array


```haxe
static public function flatten<T>(arrs: Array<Array<T>>): Array<T> 
```
produces an Array from an Array of Arrays.


```haxe
static public function interleave<T>(alls: StdArray<StdArray<T>>): Array<T> 
```
Weaves an `Array` of arrays so that `[ array0[0] , array1[0] ... arrayn[0] , array0[1], array1[1] ... ]`. Continues to operate to the length of the shortest array, and drops the rest of the elements.
  

```haxe  
static public inline function is_defined<T>(self:StdArray<T>):Bool
```
Return true if the length of `self` is greater than 0.


```haxe
static public function cons<T>(self:StdArray<T>,t:T):Array<T>
```
Return an `Array` including `t:T` at the beginning. 
  

```haxe
static public function snoc<T>(self:StdArray<T>,t:T):Array<T>
```
Return an `Array` including `t:T` at the end. 
  
  

```haxe
static public inline function set<T>(self:StdArray<T>,i:Int,v:T):Array<T>
```
Produces an `Array` wherein the value at `self[i]` is  `t`.
  

```haxe
static public inline function get<T>(self:StdArray<T>,i:Int):T
```
Produces the element of `self` at index `i`


```haxe
static public function head<T>(self:StdArray<T>):Option<T>
```
Produces the first element of `self` as an `Option`, `Option.None` if the `Array` is empty or the value is null. 
   
  

```haxe
static public function tail<T>(self:StdArray<T>):Array<T>
```
Produces an `Array` of all elements after the first.
  
  

```haxe
static public function last<T>(self:StdArray<T>):Option<T>
  
```
Produces the last element of `self` if defined.


```haxe
static public function copy<T>(self:StdArray<T>):Array<T>
```
Produces a seperate, shallow copy of `self`.


```haxe  
static public function concat<T>(self:StdArray<T>,that:Iterable<T>):Array<T>
```
Produces an `Array` containing the contents of `self` followed by the contents of `that`.


```haxe
static public function bind_fold<T,Ti,TT>(self:StdArray<T>,pure:Ti->TT,init:Ti,bind:TT->(Ti->TT)->TT,fold:T->Ti->Ti):TT
```
Achieves a flat_map by passing the `bind` function as a parameter.



```haxe
static public function reduce<T,TT>(self:StdArray<T>,unit:Void->TT,pure:T->TT,plus:TT->TT->TT):TT
```
Folds `self` into `TT` by first constructing a `pure` value from each element.
  

```haxe
static public function map<T,TT>(self:StdArray<T>,fn:T->TT):Array<TT>
```
Produces an `Array` containing the results of `f` applied to `self`.
  

```haxe
static public function mapi<T,TT>(self:StdArray<T>,fn:Int->T->TT):Array<TT>
```
Applies function `f` to each element in `self`, passing the index in the left hand parameter, returning an `Array`.


```haxe
static public function flat_map<T,TT>(self:StdArray<T>,fn:T->Iterable<TT>):Array<TT>
```
Applies function `f` to each element in `self`, concatenating and returning the results.


```haxe
static public function lfold<T,TT>(self:StdArray<T>,fn:T->TT->TT,memo:TT):TT
```
Using starting var `tt`, run `f` on each element, storing the result, and passing that result into the next call:

```haxe
[1,2,3,4,5].lfold( function(next,memo) return init + v, 100 ));//(((((100 + 1) + 2) + 3) + 4) + 5)
``` 


```haxe
static public function lfold1<T>(self:StdArray<T>,fn:T->T->T):Option<T>
```
Performs a `lfold`, using the first value of `arr` as the `memo` value.
  

```haxe
static public function rfold<T,TT>(self:StdArray<T>,fn:T->TT->TT,z:TT):TT 
```
As with `lfold` but working from the right hand side.


```haxe
static public function lscan<T>(self:StdArray<T>,f: T -> T -> T,init: T): Array<T> 
```
Takes an initial value which is passed to function `f` along with each element
one by one, accumulating the results. `f(next,memo)`
  

```haxe
static public function lscan1<T>(self:StdArray<T>,f: T -> T -> T): Array<T>
```
As `lscan`, but using the first element as the second parameter of `f`


```haxe
static public function rscan<T>(self:StdArray<T>,init: T, f: T -> T -> T): Array<T>
```
As `lscan` but from the end of the `Array`.


```haxe
static public function rscan1<T>(self:StdArray<T>,f: T -> T -> T): Array<T>
```
As `rscan`, but using the first element as the second parameter of `f`


```haxe
static public function filter<T>(self:StdArray<T>,fn:T->Bool):Array<T>
  
```
Call `f` on each element in `self`, returning an Array where `f(e) = true`.
 

```haxe
static public function map_filter<T,TT>(self:StdArray<T>,fn:T->Option<TT>):Array<TT>
```
Call `f` on each element in `self`, returning an `Array` where the result is `Some(tt:TT)`
  

```haxe
static public function whilst<T>(self:StdArray<T>,fn:T->Bool):Array<T>
```
As with `filter`, but produces nothing more after the predicate `p` first returns `false`.
 

```haxe
static public function ltaken<T>(self:StdArray<T>,n):Array<T>
```
Produces an `Array` from `self[0]` to `self[n]`


```haxe
static public function ldropn<T>(self:StdArray<T>,n):Array<T>
```
Produces an Array from `self[n]` up to and including the last element.
                                    

```haxe
static public function rdropn<T>(self:StdArray<T>,n:Int):Array<T>
```
Produces an `Array` from `self[0]` to `self[a.length-n]`.
 

```haxe
static public inline function ldrop<T>(self: StdArray<T>, p: T -> Bool): Array<T>
```
Drops values from `self` while the predicate returns `true`.
  

```haxe
static public function search<T>(self:StdArray<T>,fn:T->Bool):Option<T>
```
Produces an `Option.Some(element)` the first time the predicate returns `true`, `None` otherwise.


```haxe
static public function all<T>(self:StdArray<T>,fn:T->Bool):Bool
```
Produces `true` if the predicate returns `true` for all elements, `false` otherwise.


```haxe
static public function any<T>(self:StdArray<T>,fn:T->Bool): Bool
```
Produces `true` if the predicate returns `true` for *any* element, `false` otherwise.
  

```haxe
static public function zip_with<T,Ti,TT>(self:StdArray<T>,that:StdArray<Ti>,fn:T->Ti->TT
:Array<TT>
```

Produces an `Array` of `f(l_element,r_element)`. Goes to the shorter of the two `Array`s. 
	 


```haxe
static public function cross_with<T,Ti,TT>(self : Array<T>, that : Array<Ti>,fn : T ->
Ti -> TT):Array<TT>
```
from thx.core
It returns the cross product between two arrays.
```haxe
var r = [1,2,3].cross_with([4,5,6],(lhs,rhs) -> [lhs,rhs]);
trace(r); // [[1,4],[1,5],[1,6],[2,4],[2,5],[2,6],[3,4],[3,5],[3,6]]
```    


```haxe
static public function difference_with<T>(self:Array<T>, that:Array<T>,eq:T->T->Bool)
```
Produces an Array that contains all elements from `self` which are not elements of `that`, using `f`.
If `self` contains duplicates, the resulting `Array` contains duplicates.


```haxe
static public inline function union_with<T>(self:Array<T>, that:Array<T>,eq:T->T->Bool)
```
Produces an `Array` that contains all elements from `self` which are also elements of `that`.
If `self` contains duplicates, so will the result.


```haxe
static public function unique_with<T>(self:StdArray<T>,eq:T->T->Bool):Array<T>{
  
```

```haxe
static public function nub_with<T>(self:StdArray<T>,f: T -> T -> Bool): Array<T>
```
Produces an `Array` with no duplicate elements as determined by `f`. 



```haxe
static public inline function intersect_with<T>(self: StdArray<T>, that: StdArray<T>,f:
T -> T ```-> Bool): Array<T> 

Intersects two `Array`s, determining equality by `f`.


```haxe
static public inline function reversed<T>(self: StdArray<T>): Array<T> 
```
Produces an `Array` with the elements in reversed order.


```haxe
static public inline function count<T>(self: StdArray<T>, f: T -> Bool): Int 
```
Counts some property of the elements of `self` using predicate `p`. 
   For the length of the Array @see `size()`.


```haxe
static public inline function size<T>(self: StdArray<T>): Int

```
Returns the number of elements in `self`


```haxe
static public inline function index_of<T>(self: StdArray<T>, t: T->Bool): Int 
```
Produces the index of element `t`. For a function producing an `Option`, see `findArrayOf`.
  

```haxe
static public inline function has<T>(self: StdArray<T>,obj:T): Option<Int>
```
Determines if a value is contained in `self` by identity.


```haxe
static public inline function partition<T>(self: StdArray<T>,f: T -> Bool): { a : StdArray<T>, b :  StdArray<T> }
```

Produces a tuple containing two `Array`s, `a` being elements where `f(e) == true`, and `b`, the rest.


```haxe
static public function chunk<T>(self : StdArray<T>, size : StdArray<Int>) :
Array<A```rray<T>> return

Produces an `Array` of `Array`s of size `size`.
  

```haxe
static public function pad<T>(self:StdArray<T>,len:Int,?val:T):Array<T>
```
Pads out to `len` with `val`, ignores if `len` is less than `Array.size()`.

 

```haxe
static public inline function fill<T>(self:StdArray<T>,def:T):Array<T>
```
Fills `null` values in `self` with `def`.
  

```haxe
static public function toIterable<T>(self:StdArray<T>
:Iterable<T>                                    return self;
```


```haxe
static public inline function toMap<T>(self:StdArray<Void -> { a : String, b : T }>
:Map<St```ring,T>

Produces a `haxe.ds.Map` 


```haxe
static public function random<T>(self:StdArray<T>):Null<T>
```

```haxe
static public function shuffle<T>(self: StdArray<T>): Array<T>
```

```haxe
static public function and_with<T>(self:Array<T>,that:Array<T>,eq:T->T->Bool):Bool;
```

```haxe
static public function rotate<T>(self:Array<T>,num:Int):Array<T>
```