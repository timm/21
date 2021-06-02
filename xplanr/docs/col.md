

```lua
-- vim: ts=2 sw=2 sts=2 et :
-- Routines for all columns.
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

local Lib,Thing = require("lib"),require("thing")
local Col = Lib.class(Thing)

function Col:_init(at,txt)
  self.at, self.txt, self.n = at,txt,0 
  self.w = (txt and txt:match("-")) and -1 or 1 end

function Col:add(x,n)
  if type(x)=='table' then
    for _,v in pairs(x) do self:add(v,n) end 
  else
    if x ~= "?" then
      n = n or 1
      self.n = self.n + n
      self:add1(x,n) end end
  return x end

function Col:norm(x)
  return x == "?" and x or self:norm1(x) end

function Col:dist(x,y)
  return x == "?" and y == "?" and 1 or self:dist1(x,y) end

return Col
