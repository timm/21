moon=require "moon"
col=require "col"
p=moon.p

egs={}
egs.all = -> [f() for k,f in  pairs egs when k != "all"]

egs.sym = ->
  s=col.Sym!
  s\adds {"a", "a", "a", "a", "b", "b", "c"}
  assert 4==s.all.a
  print s\ent()

egs.cols = ->
  it=col.Cols {"A?" ,"B","C-"}
  assert #it.ys == 1
  assert it.ys[1].w == -1
  assert #it.xs == 1
  assert #it.all == 3

egs.all()
