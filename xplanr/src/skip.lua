-- vim: ts=2 sw=2 sts=2 et :
-- Columns we are going to ignore
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

local Lib=require("lib")
local Skip={}

function Skip.new(at,txt) 
  return Lib.isa(Skip, {at=at or 0,txt=txt or "",n=0}) end

function Skip:add(x,_)  return x end

return Skip
