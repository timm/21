-- vim: ts=2 sw=2 sts=2 et :
-- Testing Syms
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

package.path = '../src/?.lua;' .. package.path 
local Lib=require("lib")
local Col=require("col")
local Sym=require("sym")

do
  local s=Sym.new(10,"ada")
  Col.add(s,{"a","a","a","a","b","b","c"})
  assert(s.mode == "a","mode test")
  assert(s.seen.b==2, "count test")
  assert(1.37 <= s:ent() and s:ent() <= 1.38,"ent test")
end

Lib.rogues()
