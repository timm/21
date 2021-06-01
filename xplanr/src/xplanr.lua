-- vim: ts=2 sw=2 sts=2 et;
-- simple explanation/optimizer/data miner/planner
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

local Lib=require("lib")
local o, oo, isa, rogues = Lib.o, Lib.oo, Lib.isa, Lib.rogues
local rand,seed = Lib.rand, Lib.seed
local add,dist,norm

local the = {data="test/data/aa",
                p=2,
                seed=1}

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

function norm(t,x)
  return x == "?" and x or t:norm(x) end

function dist(t,x,y)
  return x == "?" and y == "?" and 1 or t:dist(x,y) end

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

function Num:dist(x,y)
  if      x=="?" then y = self:norm(y); x=y<0.5 and 1 or 0 
  else if y=="?" then x = self:norm(x); y=x<0.5 and 1 or 0
  else                x,y = self:norm(x), self:norm(y) end end
  return  math.abs(x - y) end

function Num:norm(x)
  return (x-self.lo) / (self.hi -  self.lo + 1E-32) end

--- Sym ----------------------------------------------------
local Sym={}

function Sym.new(at,txt) 
  return isa(Sym, {at=at or 0,txt=txt or "",
                   n=0,seen={},most=0,mode=nil}) end

function Sym:add(x,   n)
  local d = (self.seen[x] or 0) + n
  self.seen[x] = d
  if d > self.most then self.most, self.mode = d, x end end

function Sym:dist(x,y) return x==y and 0 or 1 end

function Sym:norm(x) return x end

--- Row ---------------------------------------------------
local Row={}

function Row.new(t)
  return isa(Row, {_tab=t, cells={}}) end

function Row:dist(other,cols, the)
  local d,n=0,1E-32
  for _,col in pairs(cols or _tab.x) do
    local inc=col:dist(self.cells[col.at], other.cells[col.at])
    d = d + inc^the.p
    n = n + 1 end
  return (d/n)^the.p end

--- Tbl ---------------------------------------------------
local Tbl={}

function Tbl.new(rows) 
  return isa(Tbl,{rows={}, x={}, y={}, all={},klass=nil}) end

function Tbl:add(t)
  t = t.cells and t.cells or t
  if self.all then
    for _, col in pairs(self.all) do col:add(t[col.at]) end
    self.rows[#self.rows + 1] = Row(t)
  else
    t.cols = self:cols0(t) end end

function Tbl:cols0(t,  what,new) 
  for at,txt in pairs(t) do
    what = txt:find("?") and Skip or (
           txt:sub(1,1):match("%u+") and Num or Sym)
    new  = what(at,txt)
    self.all[#self.all+1] = new
    if not txt:find("?") then
      if txt:find("!") then t.klass = new end 
      if   txt:match("[<>!]") then 
           self.y[#self.y+1] = new 
      else self.x[#self.x+1] = new end end end end

--- demos --------------------------------------------------
local n=Num.new(10,"asds-")
add(n, {9,2,5,4,12,7,8,11,9,3,7,4,12,5,4,10,9,6,9,4})
o(n)

local s=Sym.new(10,"ada")
add(s,{"a","a","a","a","b","b","c"})
o(s)

-- sanity check --------------------------------------------
rogues()
