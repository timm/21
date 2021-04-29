#!/usr/bin/env lua
-- vim: ts=2 sw=2 et :

--- Data storage routines.
-- @module data
-- @author Tim Menzies
-- @license 2021, MIT

local lib=require "etc"

---------------------------------
local Col,Sym,Num,Skip,Row,Rows

---------------------------------
local goalp,klassp,nump,weight,skip,what,col,add

--- Is `s` the name of a goal column?
function goalp(s, c) return s:find("+") or s:find("-") or s:find("!")  end

--- Is `s` the name of a class column?
function klassp(s, c) return s:find("!") end

--- Is `s` the name of a numeric column?
function nump(s) return s:sub(1,1):match("[A-Z]") end

--- What is the weight of a column called `s`?
function weight(s) return s:find("-") and -1 or 1 end

--- Should I skip this row, column?
function skip(s) return s:find("?") end

--- What kind of column should be created from `s`?
function what(s) return skip(s) and Skip or (nump(s) and Num or Sym) end

--- Make a new column, and if `inits` is supplied, then  load it data.
function col(at,txt, inits)
  local new = lib.isa(what(txt), {at=at, txt=txt, w=weight(txt)}) 
  for _,y in pairs(inits or {}) do new:add(y) end
  return new end

--- Unless skipping, increment `n` and add `x`.
function add(col,x) if x~="?" then col.n = col.n+1; col:add(x) end end

-- ---------------------------------------
--- Column for things we just ignore,
-- @type Skip
Skip= {at=0, txt="", n=0}

function Skip:add(x) return true end
function Skip:mid()  return "?" end

-- ---------------------------------------
--- Column to summarize `Sym`bolic columns.
Sym = {at=0, txt="", n=0, most=0, seen={}}

function Sym:add(x) 
  local tmp = (self.seen[x] or 0) + 1
  self.seen[x] = tmp 
  if tmp > self.most then self.most, self.mode = tmp,x end end 
    
function Sym:ent(   e)
  e=0
  for _,v in pairs(self.seen) do e = e-v/self.n*math.log(v/self.n,2) end
  return e end

function Sym:mid(x) return i.mode end 
function Sym:spread()  return self:ent() end

-------------------------------------
Num = {at=0, txt="", n=0, mu=0, sd=0, m2=0, lo=1e32,  hi=-1e32, _all={}}
function Num:add(x)
  local d = x - self.mu
  self.mu = self.mu + d/self.n
  self.m2 = self.m2 + d*(x-self.mu)
  self.sd = self.n<2  and 0 or (self.m2<0 and 0 or ((self.m2/self.n)^0.5))
  self.lo = math.min(self.lo, x)
  self.hi = math.max(self.hi, x)
  self._all[#self._all+1] = x end

function Num:mid(x) return self.mu end
function Num:spread(x) return self.sd end

-------------------------------------
Rows= {rows={}, txt="", cols={}, xs={}, ys={}}

function Rows:add(t) 
  t = t._isa==Row and t.calls or t
  if #self.cols>0 then
    for at,v in pairs(t) do add(self.cols[at], v) end 
    self.rows[#self.rows+1] = t
  else
    for at,v in pairs(t) do 
      local new,where
      new  = col(at,v) 
      where = goalp(v) and self.ys or self.xs
      if klassp(v) then self.klass= new end
      where[#where+1] = new
      self.cols[#self.cols + 1] = new end end end

return {add=add, Sym=Sym, Num=Num,
        Row=Row, Rows=Rows}
