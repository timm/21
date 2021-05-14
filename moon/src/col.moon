moon=require "moon"
p=moon.p

class Col
  new:  (txt='',at=0) => 
    @w, @n, @at, @txt = 1,1, at, txt
    if txt:find("<") @w = -1
  adds: (lst)         => [@\add(x) for x in *lst]
  add:  (x)           =>
   if x != "?"
     @n += 1
     @\add1(x)

class Sym extends Col
   new: (txt,at) =>
     super txt,at
     @all, @most, @mode = {}, 0, nil
   add1: (x) =>
     @all[x] = (@all[x] or 0) + 1
     @most,@mode = @all[x],x if @all[x] > @most
   ent: (    e=0) =>
     for _,v in pairs @all do e -= v/@n*math.log(v/@n,2)
     return e
   mid: => return @mode
   spread: =>  @\ent!

class Num extends Col
   new: (txt,at) =>
     super txt,at
     @mu, @sd, @m2, @lo, @hi, @all = 0,0,0, math.inf, -math.inf,{}
 
{:Sym, :Num}
