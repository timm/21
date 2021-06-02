

```lua
-- vim: ts=2 sw=2 sts=2 et :
-- Routines for all columns.
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

Col={}

function Col.add(t,x,n)
  if type(x)=='table' then
    for _,v in pairs(x) do Col.add(t,v,n) end 
  else
    if x ~= "?" then
      n = n or 1
      t.n = t.n+n
      t:add(x,n) end end
  return x end

function Col.norm(t,x)
  return x == "?" and x or t:norm(x) end

function Col.dist(t,x,y)
  return x == "?" and y == "?" and 1 or t:dist(x,y) end

return Col
