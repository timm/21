-- vim: ts=2 sw=2 sts=2 et :
-- Tables store rows, summarized in columns.
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

local Tbl={}

function Tbl.new(rows) 
  return isa(Tbl,{rows={}, x={}, y={}, all={},klass=nil}) end

function Tbl:add(t)
  t = t.cells and t.cells or t
  if self.all then
    for _, col in pairs(self.all) do col:add(t[col.at]) end
    self.rows[#self.rows + 1] = Row(t)
  else
    t.cols = self:cols0(t) end end

function Tbl:cols0(t,  what,new) 
  for at,txt in pairs(t) do
    what = txt:find("?") and Skip or (
           txt:sub(1,1):match("%u+") and Num or Sym)
    new  = what(at,txt)
    self.all[#self.all+1] = new
    if not txt:find("?") then
      if txt:find("!") then t.klass = new end 
      if   txt:match("[<>!]") then 
           self.y[#self.y+1] = new 
      else self.x[#self.x+1] = new end end end end

return Tbl
