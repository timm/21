import random
def per(a,p=.5): return a[int(p*len(a))]

class Remedian:
  def __init__(i,n=32): i.n,i.too,i._all,i.ok = n,None,[],False
  def median(i): return i.too.median() if i.too else per(i.all())
  def all(i):
    if not i.ok: i._all = sorted(i._all)
    i.ok = True
    return i._all
  def add(i,x):
    i._all += [x]
    i.ok = False
    if len(i._all) > i.n: 
      i.too = i.too or Remedian(n = i.n)
      i.too.add( per(i.all()) )
      i._all = []
    return x

def r3(x): return round(x,3)

for _ in range(50):
  r   = Remedian(n=32)
  all = []
  for _ in range(256): 
    all += [ r.add( random.random() ) ]
  got, want = r.median(), per(sorted(all))
  print(*[r3(x) for x in [100*abs(got-want)/want,got,want]])

