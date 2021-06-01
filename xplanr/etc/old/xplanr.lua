-- vim: ts=2 sw=2 sts=2 et :
-- simple explanation/optimizer/data miner/planner
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

local Lib=require("lib")
local o, oo, isa, rogues = Lib.o, Lib.oo, Lib.isa, Lib.rogues
local rand,seed = Lib.rand, Lib.seed
local add,dist,norm

local the = {data="test/data/aa",
                p=2,
                seed=1}

--- all columns -------------------------------------------
function add(t,x,n)
  if type(x)=='table' then
    for _,v in pairs(x) do add(t,v,n) end 
  else
    if x ~= "?" then
      n = n or 1
      t.n = t.n+n
      t:add(x,n) end end
  return x end

function norm(t,x)
  return x == "?" and x or t:norm(x) end

function dist(t,x,y)
  return x == "?" and y == "?" and 1 or t:dist(x,y) end


--- demos --------------------------------------------------
local n=Num.new(10,"asds-")
add(n, {9,2,5,4,12,7,8,11,9,3,7,4,12,5,4,10,9,6,9,4})
o(n)

local s=Sym.new(10,"ada")
add(s,{"a","a","a","a","b","b","c"})
o(s)

-- sanity check --------------------------------------------
rogues()
