-- vim: ts=2 sw=2 sts=2 et :
-- Simple base class that can pretty print.
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

local Lib=require("lib")

local Thing=Lib.class()

function Thing:__tostring()
  local s, sep, lst, t = "", "", {}, self or {}
   for k,v in pairs(t) do
     if  k ~= "class" and k ~= "super" then
       if "_" ~= k:sub(1, 1) then
         lst[#lst+1] = k end end end
   table.sort(lst)
   for k=1,#lst do
     s = s .. sep .. lst[k] .. "=" .. tostring(t[lst[k]]) 
     sep=", " end 
   return "<" .. s .. ">" end

return Thing
