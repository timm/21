import random
def per(a,p=.5): return a[int(p*len(a))]
def dot(x):      print(x,end="")

class Ordered: 
  def __init__(i): i._all=[]; i.unsorted=True
  def __len__(i):  return len(i._all)
  def add(i,x):    i._all += [x]; i.unsorted=True
  def median(i):   return per(i.all(),.5)
  def all(i):
    if i.unsorted: i._all.sort()
    i.unsorted=False
    return i._all

class Remedian:
  def __init__(i,max=16): i.has, i.max, i.after = Ordered(), max, None
  def median(i):         return (i.after if i.after else i.has).median()
  def add(i,x):
    i.has.add(x)
    if len(i.has) > i.max: 
      i.after = i.after or Remedian(max=i.max)
      i.after.add(i.has.median())
      i.has = Ordered()

def r3(x): return round(x,4)

for _ in range(50):
  r=Remedian(max=16)
  all=[]
  for _ in range(10): 
    for _ in range(100): 
      n=random.random()
      r.add(n)
      all += [n] # all.sort(); per(all,.5)
    r.median()
  got,want=r.median(), per(sorted(all),.5)
  print("",*[r3(x) for x in [100*abs(got-want)/want,got,want]])

