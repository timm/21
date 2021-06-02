

```lua
-- vim: ts=2 sw=2 sts=2 et :
-- Summarizing numeric columns.
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

local Lib=require("lib")
local Num={}

function Num.new(at,txt) 
  return Lib.isa(Num, {at=at or 0,txt=txt or "",
                   w= (txt and txt:match("-")) and -1 or 1,
                   n=0,mu=0,m2=0,lo=1E31,hi= -1E31}) end

function Num:add(x,_) 
  local d = x - self.mu
  self.mu = self.mu + d/self.n
  self.m2 = self.m2 + d*(x - self.mu)
  if x > self.hi then self.hi = x end
  if x < self.lo then self.lo = x end
  self.sd = (self.n  < 2 and 0 or (
             self.m2 < 0 and 0 or (
            (self.m2/(self.n-1)))))^0.5 end

function Num:dist(x,y)
  if      x=="?" then y   = self:norm(y); x=y<0.5 and 1 or 0 
  else if y=="?" then x   = self:norm(x); y=x<0.5 and 1 or 0
  else                x,y = self:norm(x), self:norm(y) end end
  return  math.abs(x - y) end

function Num:mid(x)    return self.mu end
function Num:norm(x)   return (x-self.lo)/(self.hi-self.lo+1E-32) end
function Num:spread(x) return self.sd end

return Num
