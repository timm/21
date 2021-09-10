# -- vim: ts=2 sw=2 sts=2 et :
import re

class o:
  def __init__(i,**kv)  : i.__dict__.update(**kv)
  def __repr__(i): return i.__class__.__name__+"{"+dstring(i.__dict__)+"}"

def dstring(d,  skip="_"):
    return " ".join([f":{k} {v}" for k,v in sorted(d.items()) if k[0] != skip])

def csv(file, sep=",", ignore=r'([\n\t\r ]|#.*)'):
  with open(file) as fp:
    for s in fp:
      s=re.sub(ignore,"",s)
      if s:
        yield s.split(sep)

def num(x): return x if x == "?" else float(x)

def data(file):
  d = o(cols=[], rows=[], close={}, closest=0, x={}, y={},ranges={})
  for id,row in enumerate(csv(file)):
    if d.cols:
      d.rows += o(id=id, ranges=[], cells=[f(x) for f,x in zip(d.cols,row)])
      d.close[id]={}
    else:
      for c,x in enumerate(row):
        d.cols +=  [num if x[0].isupper() else str]
        if "?" not in x:
          what = d.y if "+" in x or "-" in x or "!" in x else d.x
          what[c] = c
  return d

def ranges(d):     
  for c in d.x:
    if d.cols[c] == num: 
      lst         = [(row[c],row) for row in d.rows if row[c] != "?"]
      d.ranges[c] = [closer(d,range1) for range1 in ranges1(lst,col=col)]

def ranges1(lst,col=0):
  lst     = sorted(lst, key=first)
  iota    = sd(lst, key=first) * .35
  big     = len(lst)**.5
  lo      = x[0][0]
  range1  = o(col=col, lo=lo, hi=lo, has=[])
  out    += [range1]
  for i,(x,row) in enumerate(lst):
    if i < len(lst) - big:
      if len(range1.has) >= big:
         if range1.hi - range1.low > iota:
           if x != lst[i+1][0]:
             range1 = o(col=col, lo=x, hi=x, has=[])
             out += [range1]
    range1.hi   = x 
    range1.has += [row]
  return out

def closer(d, range1):
  for row1 in one.has:
    for row2 in one.has:
      i1,i2 = id(row1), id(row2)
      if i1 < i2:
        old = d.close[i1].get(i2,0)
        new = d.close[i1][i2] = old + len(one.has)/len(lst)
        if new > d.closest: 
          d.closest = new

def dist(d, row1,row2):
   i1,i2 = id(row1), id(row2)
   if i1 > i2: i1,i2 = i2,i1
   if i1 in d.close:
     if i2 in d.close[i2]:
       return 1 - d.close[i1][i2] / d.closest
   return 1 

def cluster(d,depth=4):
  def far(rows, r1):
    random.shuffle(rows)
    rows = sorted([(dist(d,r1,r2),r2) for r2 in rows[:128]], key=first)
    return rows[int(.9*len(rows))]
  #---------------- 
  def cosine(row,l,r,c):
     return (dist(d,row,l)**2 + c**2 - dist(d,row,r)**2)/(2*c+1E-32) 
  #---------------- 
  def recurse(rows,depth):
    if depth < 1 or len(rows) < 4:
      out += [o(scored=[],has=rows)]
    else:
      one  = random.choose(rows)
      _,l  = far(rows,one)
      c,r  = far(rows,l)
      for row in rows: row.x = cosine(row,l,r,c)
      rows = sorted(rows, key=lambda row: row.x)
      mid  = len(rows)//2
      recurse(rows[:mid], depth - 1)
      recurse(rows[mid:], depth - 1)
  #---------------- 
  out = []
  recurse(d.rows,depth)
  return out

def first(a): return a[0]
def same(x): return x
def per(a,p=0.5) : return a[int(p*len(a))]
def sd(a,key=same): 
  return (key(per(a,.9)) - key(per(a,.1))) / 2.56 
