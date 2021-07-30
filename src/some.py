import math
import random
from remedian1 import Median
def per(a,p=.5): return a[int(p*len(a))]

r=random.random
def dot(x): print(x,end="")

class Num :
  def __init__(i):
    i.med=Median()
    i.n   =  i.mu  = i.sd = i.m2 = 0

  def add(i,x):
    i.n    += 1
    delta   = x - i.mu
    i.mu   += delta/i.n
    i.m2   += delta*(x - i.mu)
    i.sd = (i.m2/i.n)**0.5
    if i.n<100: 
      i.med.add(x)
    else:
      z0 = i.mu/i.sd
      z  =  abs(x - i.mu)/i.sd/z0
      if r() < z/8:
          i.med.add(x)

class Some:
  def __init__(i): i._all,i.ok,i.b4 = [], False,[]
  def add(i,x):
    i._all += [x]
    if len(i._all) > 100:
      i.b4 = sorted(i.b4 + i._all[::5])[::5]
      i._all = []
  def median(i): return per(i.b4)

for _  in range(30):
  n=Some()
  for _ in range(10000):
    n.add( r())
  print(n.median())


