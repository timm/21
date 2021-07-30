import random
def per(a,p=.5): return a[int(p*len(a))]

class Sample:
  def __init__(i, init=[], size=128):
    i.n, i._all, i.max, i.sorted = 0, [], size, False
    [i.add(x) for x  in init]
  def add(i,x):
    rand=random.random
    i.n += 1
    now = len(i._all)
    if now < i.max:
      i.sorted=False; i._all += [x]
    elif rand() <= now/i.n:
      i.sorted=False; i._all[int(rand()*now)]= x
    return i
  def all(i):
    if not i.sorted: i._all=sorted(i._all)
    i.sorted = True
    return i._all
  def median(i): return per(i.all())

def r3(x): return round(x,3)

for _ in range(20):
  s = Sample(size=128)
  all = []
  for _ in range(10**3): 
    n = random.random()
    all += [n]
    s.add(n); s.median()
  got, want = s.median(), per(sorted(all))
  print(*[r3(x) for x in [100*abs(got-want)/want,got,want]])

