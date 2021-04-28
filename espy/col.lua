#!/usr/bin/env lua
-- vim: ts=2 sw=2 et :
lib=require "lib"

local Col = {at=0, txt=""}
local Sym = {at=0, txt="", n=0, most=0, seen={}}
local Num = {at=0, txt="", n=0, mu=0, sd=0, m2=0, lo=1e32,  hi=-1e32, _all={}}
local Skip= {at=0, txt="", n=0}
local Row = {cells={}} 
local Tab = {rows={}, txt="", cols={}, xs={}, ys={}}

local function goalp(s, c) c=s:sub(1,1); return lib"+"==c or "-"==c or "!"==s end
local function nump(s)    return s:sub(1,1):match("[A-Z]") end
local function weight(s)  return s:find("<") and -1 or 1 end
local function skip(s)    return s:find("?") end
local function what(s)    return skip(s) and Skip or (nump(s) and Num or Sym) end

function col(at,txt, inits)
  new =  lib.isa(what(txt),{at=at,txt=txt,w=weight(txt)}) 
  for _,y in pairs(inits) do new:add(y) end
  return new end

function add(col,x)
  if x~="?" then self.n = self.n+1; col:add(x); end end

-------------------------------------
function Skip:add(x) return true end
function Skip:mid()  return "?" end

-------------------------------------
function Sym:add(x) 
  local tmp = (self.seen[x] or 0) + 1
  self.seen[x] = tmp 
  if tmp > self.most then self.most, self.mode = tmp,x end end 
    
function Sym:ent(   p,e)
  e=0
  for _,v in pairs(self.seen) do e=e-v/self.n*math.log(v/self.n,2) end
  return e end

function Sym:mid(x) return i.mode end 
function Sym:spread()  return self:ent() end

-------------------------------------
function Num:add(x)
  local d = x - self.mu
  self.mu = self.mu + d/self.n
  self.m2 = self.m2 + d*(x-self.mu)
  self.sd = self.n<2 and 0 or (self.m2<0 and 0 or (self.m2/self.n)^0.5)
  self.lo = math.min(self.lo, x)
  self.hi = math.max(self.hi, x)
  self._all[#self._all+1] = x end

function Num:mid(x) return self.mu end
function Num:spread(x) return self.sd end

-------------------------------------
function Tab:add(t) 
  t = t._isa==Row and t.calls or t
  if #t.cols>0 then
    for at,v in pairs(t) do add(t.cols[at], v) end 
    t.rows[#t.rows+1] = t
  else
    for at,v in pairs(t) do 
      new  = col(at,v) 
      what = goalp(v) and t.ys or t.xs
      what[#what+1] = new
      t.cols[#t.cols + 1] = new end end end
