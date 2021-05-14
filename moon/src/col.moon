moon=require "moon"
p=moon.p

weight= (s)-> if s\find"-" then -1  else 1
isKlass=(s)-> s\find"!"
isSkip= (s)-> s\find"?"
isNum=  (s)-> s\sub(1,1)\match"[A-Z]"
isY=    (s)-> s\find"+" or s\find"-" or isKlass s 
isX=    (s)-> not isY s 

class Col
  new:  (at=1,txt='') => 
    @n, @at, @txt, @w = 1, at, txt,  weight txt
  adds: (a)         => [@\add(x) for x in *a]
  add:  (x)         =>
   if x != "?"
     @n += 1
     @\add1 x

class Sym extends Col
   new: (at,txt) =>
     super at,txt
     @all, @most, @mode = {}, 0, nil
   add1: (x) =>
     @all[x] = (@all[x] or 0) + 1
     @most,@mode = @all[x],x if @all[x] > @most
   ent: (    e=0) =>
     for _,v in pairs @all do e -= v/@n*math.log v/@n,2
     e
   mid: => @mode
   spread: =>  @\ent!

class Skip extends Col

class Num extends Col
   new: (at,txt) =>
     @mu,@sd,@m2,@lo,@hi = 0,0,0,1E32,-1E32
     @all = {}
     super at,txt
 
class Cols
  new:(t)  =>
    @xs,  @ys, @all, @klass = {},{},{},nil
    for at,txt in pairs t do @\new1 at,txt
  new1: (at,txt) =>
    what = txt\find"?" and Skip or (isNum(txt) and Num or Sym)
    x    = what at,txt
    @all[#@all + 1]=  x
    if x.__class != Skip
      if isKlass txt then @klass = x
      if isY     txt then @ys[#@ys + 1] = x
      if isX     txt then @xs[#@xs + 1] = x
    x
  add: (a) => 
    for col in *@all do col.add a[col.at]
    t

class RowCols
  new:(a={}) =>
    @rows, @cols = {}, nil
    for x in *a do @\add x
  add: (x) => if @cols then @rows[#@rows+1]=@cols\add t else @cols= Cols x
  clone:(a={}) =>
    out = Rows [col.txt for col in *@cols.all] 
    for x in *a do out\add x
    out

:Sym, :Num, :Cols
