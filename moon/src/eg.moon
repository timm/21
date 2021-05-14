moon=require "moon"
col=require "col"
p=moon.p

egs={}
egs.all = -> [f() for k,f in  pairs egs when k != "all"]

egs.col = ->
  s=col.Sym!
  s\adds {"a", "a", "a", "a", "b", "b", "c"}
  print s.all.a
  print(s\ent())

egs.all()
