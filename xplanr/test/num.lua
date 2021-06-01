-- vim: ts=2 sw=2 sts=2 et :
-- Testing Nums
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

package.path = '../src/?.lua;' .. package.path 
Lib=require("lib")
Col=require("col")
Num=require("num")

local n=Num.new(10,"asds-")
Col.add(n, {9,2,5,4,12,7,8,11,9,3,7,4,12,5,4,10,9,6,9,4})
Lib.o(n)
