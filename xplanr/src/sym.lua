-- vim: ts=2 sw=2 sts=2 et :
-- Summarizing symbolic columns.
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

local Sym={}

function Sym.new(at,txt) 
  return isa(Sym, {at=at or 0, txt=txt or "",
                   n=0, seen={}, most=0, mode=nil}) end

function Sym:add(x,   n)
  local d = (self.seen[x] or 0) + n
  self.seen[x] = d
  if d > self.most then self.most, self.mode = d, x end end

function Sym:dist(x,y) return x==y and 0 or 1 end

function Sym:norm(x) return x end

return Sym
