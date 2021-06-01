local Lib=require("lib")
local o, oo, isa, rogues = Lib.o, Lib.oo, Lib.isa, Lib.rogues

--- all columns -------------------------------------------
function add(t,x,n)
  if type(x)=='table' then
    for _,v in pairs(x) do add(t,v,n) end 
  else
    if x ~= "?" then
      n = n or 1
      t.n = t.n+n
      t:add(x,n) end end
  return x end

--- Num ----------------------------------------------------
local Num={}

function Num.new(at,txt) 
  return isa(Num, {at=at or 0,txt=txt or "",
                   w= (txt and txt:match("-")) and -1 or 1,
                   n=0,mu=0,m2=0,lo=1E31,hi= -1E31}) end

function Num:add(x,_) 
  local d = x - self.mu
  self.mu = self.mu + d/self.n
  self.m2 = self.m2 + d*(x - self.mu)
  if x > self.hi then self.hi = x end
  if x < self.lo then self.lo = x end
  self.sd = self.n<2  and 0 or (self.m2<0 and 0 or (
            (self.m2/(self.n-1))^0.5)) end

--- Sym ----------------------------------------------------
local Sym={}

function Sym.new(at,txt) 
  return isa(Sym, {at=at or 0,txt=txt or "",
                   n=0,seen={},most=0,mode=nil}) end

function Sym:add(x,   n)
  local d = (self.seen[x] or 0) + n
  self.seen[x] = d
  if d > self.most then self.most, self.mode = d, x end
end

--- demos --------------------------------------------------
local n=Num.new(10,"asds-")
add(n, {9,2,5,4,12,7,8,11,9,3,7,4,12,5,4,10,9,6,9,4})
o(n)

local s=Sym.new(10,"ada")
add(s,{"a","a","a","a","b","b","c"})
o(s)

-- sanity check --------------------------------------------
rogues()
