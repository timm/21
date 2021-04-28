#!/usr/bin/env lua
-- vim: ts=2 sw=2 et :
eg={}

lib=require "etc"
math.randomseed(1)

assert(lib.has("bb",{"aa","bb","cc"}))
assert(not lib.has("kk",{"aa","bb","cc"}))
assert(30 == lib.any {10,20,30})

local str = "a,b,c,d"
local t   = lib.split(str)
assert(4 == #t)
assert("b" == t[2])

local t1={10,{20}}
local t2=lib.copy(t1)
t1[2][1]=30
assert(t2[2][1] == 20)


