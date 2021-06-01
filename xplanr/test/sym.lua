-- vim: ts=2 sw=2 sts=2 et :
-- Testing Syms
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

package.path = '../src/?.lua;' .. package.path 
Lib=require("lib")
Col=require("col")
Sym=require("sym")

local s=Sym.new(10,"ada")
Col.add(s,{"a","a","a","a","b","b","c"})
Lib.o(s)
