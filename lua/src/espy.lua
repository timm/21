------
local Of  = {         
  synopois = "`Col`s summarize  columns of data",
  author  = "Tim Menzies, timm@ieee.org",
  license = "MIT",
  year    = 2020,
  seed    = 1,     
  ch      = {skip="?", klass="!", more="+", less="-"}}

-- ## Objects
local Col  = {}
local Num= {ako="Num",pos=0,txt="",n=0,mu=0,m2=0,sd=0,lo=math.huge,hi= -math.huge}
local Sym  = {ako="Sym", pos=0,txt="",n=0, seen={}, most=0,mode=true}
local Skip = {ako="Skip"}
local Tab  = {ako="Tab", rows={}, cols={}, xs={}, ys={}} 

-- ## Shortcuts
local Lib  = require "lib"    
local isa  = Lib.isa
local function cell(x) return not(type(x)=="string" and x=="?") end

function Col.new(pos,txt,t) 
  what= (txt:match("^%u") and Num or Sym).new(pos,txt)
  if txt:match(" 
  
end
