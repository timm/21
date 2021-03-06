-- <img width=75 src="https://github.com/timm/keys/raw/main/etc/img/lib.png">     
-- "Keys = cluster, discretize, elites, contrast"   
-- [home](http://menzies.us/keys)         :: [lib](http://menzies.us/keys/lib.html) ::
-- [cols](http://menzies.us/keys/cols.html) :: [tbl](http://menzies.us/keys/tbl.html) ::
-- [learn](http://menzies.us/keys/learn.html)
-- <hr>
-- <a href="http://github.com/timm/keys"><img src="https://github.blog/wp-content/uploads/2008/12/forkme_left_red_aa0000.png?resize=149%2C149" align=left></a>
-- [![DOI](https://zenodo.org/badge/318809834.svg)](https://zenodo.org/badge/latestdoi/318809834)  
-- ![](https://img.shields.io/badge/platform-osx%20,%20linux-orange)    
-- ![](https://img.shields.io/badge/language-lua,bash-blue)  
-- ![](https://img.shields.io/badge/purpose-ai%20,%20se-blueviolet)  
-- [![Build Status](https://travis-ci.com/timm/keys.svg?branch=main)](https://travis-ci.com/timm/keys)   
-- ![](https://img.shields.io/badge/license-mit-lightgrey)
--------------------
local Of  ={
  synopois= "Misc lua routines",
  author  = "Tim Menzies, timm@ieee.org",
  license = "MIT",
  year    = 2020 }

-- Return any item in a list
local function any(a) return a[1 + math.floor(#a*math.random())] end

-- Split the string `s` on separator `c`, defaults to "." 
local function split(s,     c,t)
  t, c = {}, c or ","
  for y in string.gmatch(s, "([^" ..c.. "]+)") do t[#t+1] = y end
  return t end

-- Deep copy
local function copy(obj,   old,new)
  if type(obj) ~= 'table' then return obj end
  if old and old[obj] then return old[obj] end
  old, new = old or {}, {}
  old[obj] = new
  for k, v in pairs(obj) do new[k] = copy(v, old) end
  return new end

-- Object creation, add a unique id, bind to metatable, maybe set some initial values.
local id=0
local function isa(klass,inits,      new)
  new = copy(klass or {})
  for k,v in pairs(inits or {}) do new[k] = v end
  setmetatable(new, klass)
  klass.__index = klass
  klass.__call  = klass.new
  klass.__print = ooo
  id = id + 1
  new.id = id
  return new end 

-- Iterate on keys in sorted order
local function order(t,  i,keys)
  i,keys = 0,{}
  for key,_ in pairs(t) do keys[#keys+1] = key end
  table.sort(keys)
  return function ()
    if i < #keys then
      i=i+1; return keys[i], t[keys[i]] end end end 

-- Simple print of a flat table
local function o(z,pre) print(ooo(z,pre)) end

local function ooo(z,pre,   s,c) 
  s, c = (pre or "")..'{', ""
  for k,v in order(z or {}) do s= s..c..str(k).."="..tostring(v); c=", " end
  return s..'}' end

-- Print nested tables. 
-- Don't show private slots (those that start with `_`);
-- show slots in sorted order;
-- if `pre` is specified, then  print that as a prefix.
local function oo(t,pre,    indent,fmt)
  pre    = pre or ""
  indent = indent or 0
  if(indent==0) then print("") end
  if indent < 10 then
    for k, v in order(t or {}) do
      if not (type(k)=='string' and k:match("^_")) then
        if not (type(v)=='function') then
          fmt = pre..string.rep("|  ",indent)..tostring(k)..": "
          if type(v) == "table" then
            print(fmt)
            oo(v, pre, indent+1)
          else
            print(fmt .. tostring(v)) end end end end end end

-- Warn about locals that have escaped into the global space
local function rogues(    ignore,match)
  ignore = {
    jit=1, utf8=1,math=1, package=1, table=1, coroutine=1, bit=1, 
    os=1, io=1, bit32=1, string=1, arg=1, debug=1, _VERSION=1, _ENV=1, _G=1,
    tonumber=1, next=1, print=1, collectgarbage=1, xpcall=1, rawset=1,
    load=1, rawequal=1, tostring=1, assert=1, _assert=1, ipairs=1,
    setmetatable=1, type=1, loadfile=1, require=1, error=1, rawlen=1,
    getmetatable=1, pcall=1, dofile=1, select=1, rawget=1, pairs=1}
  for k,v in pairs( _ENV ) do
    if  not ignore[k] then
      print("-- warning, rogue variable ["..k.."]") end end end 

-- Return each row, split on ",", numstrings coerced to numbers,
-- kills comments and whitespace.
local function csv(file,     stream,tmp,t)
  stream = file and io.input(file) or io.input()
  tmp    = io.read()
  return function()
    if tmp then
      tmp = tmp:gsub("[\t\r ]*","") -- no whitespace
               :gsub("#.*","") -- no comemnts
      t   = split(tmp) 
      tmp = io.read()
      if #t > 0 then 
        for j,x in pairs(t) do t[j] = tonumber(x) or x end
        return t end
    else
      io.close(stream) end end end

-----
-- Any finally...
return {any=any, split=split, copy=copy, rogues=rogues,
        csv=csv, isa=isa, order=order, 
        o=o, oo=oo, ooo=ooo}
