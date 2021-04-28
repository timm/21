#!/usr/bin/env lua
-- vim: ts=2 sw=2 et :
local eg={}

local lib=require "etc"
local col=require "col"
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
  if n==200 then lib.o(row) end
end 

-------------
local rows=lib.isa(col.Rows)
for row in lib.csv("data/auto93.csv") do rows:add(row) end

-------------
lib.rogues()
