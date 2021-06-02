-- vim: ts=2 sw=2 sts=2 et :
-- Summarizing symbolic columns.
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

local Lib,Col = require("lib"),require("col")
local Sym = Lib.class(Col)

function Sym:_init(at,txt) 
  self:super(at,txt)
  self.seen,self.most,self.mode = {},0,nil end

function Sym:add1(x,   n)
  local d = (self.seen[x] or 0) + (n or 1)
  self.seen[x] = d
  if d > self.most then self.most, self.mode = d, x end end

function Sym:ent(   e,p)
  e = 0
  for _,n in pairs(self.seen) do 
    p = n/self.n
    e = e-p*math.log(p)/math.log(2) end 
  return e end

function Sym:mid(x)     return self.mode  end
function Sym:norm1(x)   return x end
function Sym:dist1(x,y) return x==y and 0 or 1 end
function Sym:spread()   return self:ent() end

return Sym
