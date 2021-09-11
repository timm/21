#!/usr/bin/env python3
# -- vim: ts=2 sw=2 sts=2 et :
import re

class o: 
  "knows  how to print itself"
  def __init__(i, **kv)  : 
    "initialize"
    i.__dict__.update(  **kv)
  def __repr__(i): return i.__class__.__name__+"{"+dstring(i.__dict__)+"}"

def num(x): return x if x == "?" else float(x)

def data(file):
  "Create rows and columns from a csv file."
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
      lst        = [(row[c],row) for row in d.rows if row[c] != "?"]
      d.ranges[c]= [closer(d,n,range1) for n,range1 in 
                    enumerate(ranges1(lst,col=col))]

def ranges1(lst,col=0):
  "Break list  "
  lst     = sorted(lst, key=first)
  iota    = sd(lst, key=first) * .35
  big     = int( max(len(lst)/16, len(lst)**.5))
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

def dist(d, row1,row2):
   i1,i2 = id(row1), id(row2)
   if i1 > i2: i1,i2 = i2,i1
   if i1 in d.close:
     if i2 in d.close[i2]:
       return 1 - d.close[i1][i2] / d.closest
   return 1 

def cluster(d,depth=4):
  "Divide `d.rows` into a tree of  `depth`."
  def far(rows, r1):
    random.shuffle(rows)
    rows = sorted([(dist(d,r1,r2),r2) for r2 in rows[:128]], key=first)
    return rows[int(.9*len(rows))]

  def recurse(rows,depth):
    if depth < 1 or len(rows) < 9: # 4*2+1
      out += [o(scored=[],has=rows)]
    else:
      one  = random.choose(rows)
      _,l  = far(rows,one)
      c,r  = far(rows,l)
      for row in rows: 
        row.x = (dist(d,row,l)**2 + c**2 - dist(d,row,r)**2)/(2*c+1E-32) 
      rows = sorted(rows, key=lambda row: row.x)
      mid  = len(rows)//2
      recurse(rows[:mid], depth - 1)
      recurse(rows[mid:], depth - 1)

  out = []
  recurse(d.rows,depth)
  return out

def csv(file, sep=",", ignore=r'([\n\t\r ]|#.*)'):
  "Reads comma repeated files, one line  at a time."
  with open(file) as fp:
    for s in fp:
      s=re.sub(ignore,"",s)
      if s:
        yield s.split(sep)

def first(a): 
  "First item" 
  return a[0]

def same(x): 
  "Return arg"  
  return x

def per(a,p=0.5): 
  "Return pth percentile" 
  return a[int(p*len(a))]

def sd(a,key=same): 
  "Standard deviation of  list  is (.9 - .1)/2.56"
  return (key(per(a,.9)) - key(per(a,.1))) / 2.56 

def dstring(d,  skip="_"):
  "String of dictionary :key values, sorted by  key, skipping private keys"
  return " ".join([f":{k} {v}" for k,v in sorted(d.items()) if k[0] != skip])

def cli(usage,  config):
  p = argparse.ArgumentParser(prog=usage, description=__doc__, 
                formatter_class=argparse.RawTextHelpFormatter)
  add   = p.add_argument
  used  = {}
  for k, (_, b4, h) in sorted(config.items()):
    used[k[0]] = c = k[0] if k[0] in used else k[0].lower()
    if b4 == False:
      add("-"+c, dest=k, default=False, help=h, action="store_true")
    else:
      add("-"+c, dest=k, default=b4, help=h + " [" + str(b4) + "]",
           type=type(b4), metavar=k)
  return o( **p.parse_args().__dict__ )

