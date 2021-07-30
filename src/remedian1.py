import random
def per(a,p=.5): return a[int(p*len(a))]

class Median:
  def __init__(i,n=16): i._all,i.n,i.kid,i.bad = [],n,None,True
  def val(i): return i.kid.val() if i.kid else per(i.all())
  def all(i): 
    if i.bad: i._all.sort()
    i.bad = False
    return i._all
  def add(i,x):
    i._all += [x]
    i.bad = True
    if len(i._all) > i.n: 
      i.kid = i.kid or Median(n=i.n)
      i.kid.add( per(i.all()) )
      i._all = []

if __name__ ==  "__main__":
  def test():
    def r3(x): return round(x,4)
    for _ in range(20):
      r=Median(n=16)
      all=[]
      for _ in range(16): 
        for _ in range(16): 
          n=random.random()
          r.add(n)
          all += [n] # all.sort(); per(all,.5)
        r.val()
      got, want = r.val(), per(sorted(all),.5)
      print("",*[r3(x) for x in [100*abs(got-want)/want,got,want]])

  test()
