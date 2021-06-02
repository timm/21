-- vim: ts=2 sw=2 sts=2 et :
-- Testing Nums
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

package.path = '../src/?.lua;' .. package.path 
local Lib,Num=require("lib"),require("num")

do
  local n=Num(10,"asds-")
  n:add {9,2,5,4,12,7,8,11,9,3,7,4,12,5,4,10,9,6,9,4} 
  assert(n.mu == 7,"mu test")
  assert(3.06 <= n.sd and n.sd <= 3.07, "sd test")
end

Lib.rogues()
