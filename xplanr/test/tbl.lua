-- vim: ts=2 sw=2 sts=2 et :
-- testing table routines
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

package.path = '../src/?.lua;' .. package.path 
print("-- tbl")
Tbl=require("tbl")
Lib=require("lib")

do
  local t=Tbl.new()
  for row in Lib.csv("data/weather.csv") do t:add(row) end
  Lib.o(t)
end

Lib.rogues()
