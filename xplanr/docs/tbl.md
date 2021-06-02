

```lua
-- vim: ts=2 sw=2 sts=2 et :
-- Tables store rows, summarized in columns.
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

local Lib  = require("lib")
local Row  = require("row")
local Skip = require("skip")
local Col  = require("col")
local Num  = require("num")
local Sym  = require("sym")

local Tbl = {}

function Tbl.new(rows) 
  return Lib.isa(Tbl,{rows={}, x={}, y={}, all={},klass=nil}) end

function Tbl:add(t)
  t = t.cells and t.cells or t
  if #self.all>0 then
    for _, col in pairs(self.all) do Col.add(col,t[col.at]) end
    self.rows[#self.rows + 1] = Row.new(self,t)
  else
    t.cols = self:cols0(t) end end

function Tbl:cols0(t,  what,new) 
  Lib.o(t)
  for at,txt in pairs(t) do
    print(at)
    what = txt:find("?") and Skip or (
           (txt:sub(1,1):match("%u+") and Num or Sym))
    new  = what.new(at,txt)
    print(">",at,txt,Lib.oo(new))
    self.all[#self.all+1] = new
    if not txt:find("?") then
      if txt:find("!") then self.klass = new end 
      if   txt:match("[<>!]") then 
           self.y[#self.y+1] = new 
      else self.x[#self.x+1] = new end end end end

return Tbl
