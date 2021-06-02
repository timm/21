

```lua
-- vim: ts=2 sw=2 sts=2 et :
-- Summarizing symbolic columns.
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

local Lib=require("lib")
local Sym={}

function Sym.new(at,txt) 
  return Lib.isa(Sym, {at=at or 0, txt=txt or "",
                       n=0, seen={}, most=0, mode=nil}) end

function Sym:add(x,   n)
  local d = (self.seen[x] or 0) + n
  self.seen[x] = d
  if d > self.most then self.most, self.mode = d, x end end

function Sym:ent(   e,p)
  e = 0
  for _,n in pairs(self.seen) do 
    p = n/self.n
    e = e-p*math.log(p)/math.log(2) end 
  return e end

function Sym:mid(x)    return self.mode  end
function Sym:norm(x)   return x end
function Sym:dist(x,y) return x==y and 0 or 1 end
function Sym:spread(x) return self:ent() end

return Sym
