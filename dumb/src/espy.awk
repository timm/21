@include "etc"

function add( i,x,   f) { if (x!="?") {i.n++; f=i.is"Add"; return @f(i,x)}}
function mid( i,     f) { f=i.is"Mid"; return @f(i) }
function some(i,x,y, f) { f=i.is"Some"; return @f(i,x,y) }

#------------------------------------------
function Col(i,at,txt) {  
  List(i)
  i.is="Col"
  i.n = 0
  i.txt = txt ? txt : ""
  i.at = at ? at : 0 }

#------------------------------------------
function Skip(i,at,txt)  { Col(i,at,txt); i.is="Skip" }
function SkipAdd(i,x)    { return x }

#------------------------------------------
function Num(i,at,txt) {  
  Col(i,at,txt)
  i.is = "Num"
  i.w  = txt ~ /-/ ? -1 : 1
  i.lo =  10^32
  i.hi = -10^32 }

function NumNorm(i,x) { return (x - i.lo)/(i.hi - i.lo + 1E-32) }
function NumMid(i)    { return i.mu }

function NumAdd(i,x,   d) {
  x += 0
  d = x - i.mu
  i.mu += d / i.n
  i.m2 += d * (x - i.mu)
  i.sd = (i.m2 / i.n)**0.5
  if (x < i.lo) i.lo = x
  if (x > i.hi) i.hi = x 
  return x }

#------------------------------------------
function Sym(i,at,txt) {  
  Col(i,at,txt)
  i.is="Sym"
  has(i,"seen")
  i.mode=""
  i.most=0 }

function SymMid(i)    { return i.mode }

function SymAdd(i,x,   tmp) {
  tmp = i.seen[x] = i.seen[x] + 1
  if (tmp> i.most) {
    i.most = tmp
    i.mode = x }
  return x}

#------------------------------------------
function Row(i,a,t,      c) {
  List(i)
  i.is="Row"
  i.id = ID++
  has(i,"cells") 
  for(c in t.ys) i.w[c] = t.cols[c].w
  for(c in a) i.cells[c] = add(t.cols[c], a[c]) }

function RowSome(i,cols,a,   c) { for(c in cols) a[c] = i.cells[c] }

function RowBetter(i,j,    n,s1,s2,c,w,a,b) {
  n=length(i.w)
  s1=s2=0
  for(c in i.w) {
    w = i.w[c]
    a = NumNorm(tab.cols[c], i.cells[c])
    b = NumNorm(tab.cols[c], j.cells[c])
    s1 -= 2.718^(w*(a-b)/n)
    s2 -= 2.718^(w*(b-a)/n) }
  return s1/n < s2/n }

function RowCompare(_, row1,__,row2) {
  if (row1.id == row2.id) return 0
  if (RowBetter
#------------------------------------------
function Tab(i,f) {
  List(i)
  i.is = "Tab"
  has(i,"rows"); has(i,"cols"); has(i,"xs"); has(i,"ys"); has(i,"header")
  if (f) TabRead(i,f) }

function TabSome(i,cols,a, c) { for(c in cols) a[c] = mid(i.cols[c]) }
function TabRead(i,f,a)       { while(csv(a,f)) TabAdds(i,a) }
function TabAdds(i,a)         { length(i.cols) ? TabRow(i,a) : TabHeaders(i,a) }
function TabRow(i,a)          {
  "is" in a ?  moRE(i.rows,"Row",a.cells ,i)  : moRE(i.rows,"Row",a,i) }

function TabHeaders(i,a,   at,txt,what) {
  for(at in a) {
    txt  = a[at]
    i.header[at] = txt
    what = (txt ~ /\?/) ? "Skip" : ((txt ~ /^[A-Z]/) ? "Num" : "Sym")
    moRE(i.cols, what, at,txt)
    if (what != "Skip")
       txt ~/[-!\+]/ ? i.ys[at] : i.xs[at]  }}

function TabClone(i,j, inits,      r) {
  Tab(j)
  TabHeader(j, i.header)
  for(r in inits) TabRow(i, inits[r]) }

