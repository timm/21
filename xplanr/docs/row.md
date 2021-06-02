

```lua
-- vim: ts=2 sw=2 sts=2 et :
-- Handling  one example in a table.
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

local Lib=require("lib")
local Row={}

function Row.new(t,cells)
  return Lib.isa(Row, {_tab=t, cells=cells or {}}) end

function Row:dist(other,cols, the)
  local d,n=0,1E-32
  for _,col in pairs(cols or _tab.x) do
    local inc=col:dist(self.cells[col.at], other.cells[col.at])
    d = d + inc^the.p
    n = n + 1 end
  return (d/n)^the.p end

return Row
