local Of  ={
  synopois= "Misc lua routines",
  author  = "Tim Menzies, timm@ieee.org",
  license = "MIT",
  year    = 2020 }

-- ## Files
-- Read csv files, kill comments and white space,
-- skip blank lines, split on commas, coerce 
-- any numstrings to nubers,
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

-- ## Objects
-- Object creation, add a unique id, bind to metatable, maybe set some initial values.
local function isa(klass,inits,      new)
  new = copy(klass or {})
  for k,v in pairs(inits or {}) do new[k] = v end
  setmetatable(new, klass)
  klass.__index = klass
  id = id + 1
  new.id = id
  return new end 

local id=0

-- ## Arrasyts
-- Deep copy
local function copy(obj,   old,new)
  if type(obj) ~= 'table' then return obj end
  if old and old[obj] then return old[obj] end
  old, new = old or {}, {}
  old[obj] = new
  for k, v in pairs(obj) do new[k] = copy(v, old) end
  return new end

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

-- ## Meta
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

-- ## And finally:w

return {rogues=rogues, oo=oo, csv=csv, isa=isa,copy=copy}
