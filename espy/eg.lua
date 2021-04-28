#!/usr/bin/env lua
-- vim: ts=2 sw=2 et :
local eg={}

local lib=require "etc"
local col=require "col"
local powerset,watch,csv = lib.powerset,lib.watch,lib.csv
local isa,oo =  lib.isa,lib.oo
local add = col.add
math.randomseed(1)

-------------
assert(lib.has("bb",{"aa","bb","cc"}))
assert(not lib.has("kk",{"aa","bb","cc"}))
assert(30 == lib.any {10,20,30})

-------------
local str = "a,b,c,d"
local t   = lib.split(str)
assert(4 == #t)
assert("b" == t[2])

-------------
local t1={10,{20}}
local t2=lib.copy(t1)
t1[2][1]=30
assert(t2[2][1] == 20)

-------------
local n=0
for row in lib.csv("data/auto93.csv") do 
  n=n+1
  if n>1    then assert("number"==type(row[1]),tostring(n)) end 
  if n==200 then oo(row) end
end 

------------
local t={10,20,30,40,50,60,70,80,
         90,100,110,120,130,140,150}
watch(function() powerset(t) end)

-------------
local rows=isa(col.Rows)
for row in csv("data/auto93.csv") do rows:add(row) end
oo(rows.cols[2])

--------------
local n = isa(col.Num)
for _,v in pairs {600, 470, 170, 430, 300} do add(n,v) end
assert(n.mu==394)
assert(147.3 < n.sd and n.sd < 147.4)

-------------
lib.rogues()
