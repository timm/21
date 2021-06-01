local Lib={}

function Lib.isa(klass,new)
  setmetatable(new, klass)
  klass.__index = klass
  return new
end

function Lib.o(t,pre) print(Lib.oo(t,pre))  end

function Lib.oo(t,pre,     seen,s,sep,keys, nums)
  seen = seen or {}
  if seen[t] then return "..." end
  pre=pre or ""
  seen[t] = true
  if type(t) ~= "table" then return tostring(t) end
  s, sep, keys, nums = '','', {}, true
  for k, v in pairs(t) do 
    if not (type(v) == 'function') then
      if not (type(k)=='string' and k:match("^_")) then
        nums = nums and type(k) == 'number'
        keys[#keys+1] = k  end end end 
  table.sort(keys)
  for _, k in pairs(keys) do
    local v = t[k]
    if      type(v) == 'table'    then v= Lib.oo(v,pre,seen) 
    elseif  type(v) == 'function' then v= "function"
    else v= tostring(v) end
    if nums
    then s = s .. sep .. v
    else s = s .. sep .. tostring(k) .. '=' .. v end
    sep = ', ' end 
  return tostring(pre) .. '{' .. s ..'}' end

do
  local seed0 = 10013
  local seed  = seed0
  local mod   = 2147483647.0
  local mult  = 16807.0
  function Lib.rand()  seed= (mult*seed)%mod; return seed/mod end 
  function Lib.seed(n) seed= n and n or seed0 end
end

function Lib.some(x) return x end

function Lib.map(a,f,     b)
  b, f = {}, f or Lib.same
  for i,v in pairs(a or {}) do b[i] = f(v) end 
  return b
end 

function Lib.copy(t) 
  return type(t) ~= 'table' and t or Lib.map(t,Lib.copy) end

function Lib.cli(t)
  local i = 0
  while i < #t do
    i, key, now=i+1, args[i], (tonumber(args[i+1]) or args[i+1])
    key=key:sub(2)
    if t[key] then
      i = i+1
      if type(now) == type(t[key]) then d[key] = now end end end
  return t end

function Lib.rogues(    skip)
  skip = {
    jit=true, utf8=true, math=true, package=true, table=true,
    coroutine=true, bit=true, os=true, io=true, bit32=true,
    string=true, arg=true, debug=true, _VERSION=true, _G=true,
    getmetatable=true, print=true, rawequal=true, dofile=true,
    load=true, collectgarbage=true, rawget=true, loadfile=true,
    tostring=true, pairs=true, pcall=true, error=true,
    xpcall=true, select=true, assert=true, rawset=true,
    setmetatable=true, type=true, rawlen=true, next=true,
    ipairs=true, require=true, tonumber=true, warn=true}
  for k,v in pairs( _G ) do
    if not skip[k] then
      if k:match("^[^A-Z]") then
        print("-- rogue ["..k.."]") end end end end

return Lib
