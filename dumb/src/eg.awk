@include "espy"
function data(x) { return "../opt/data/" x ".csv" } 

function eg_tab1(   t) {
  Tab(t,data("weather"))
  oo(t.cols[1])
  oo(t.rows[1]) }

function eg_tab2(   t) {
  Tab(t,data("auto93"))
  oo(t.cols[7])
  oo(t.ys) }

function eg_tab3(   t,a) {
  Tab(t,data("auto93"))
  some(t,t.ys,a)
  oo(a)
  print RowBetter(t.rows[1],t.rows[2],t) }

function eg(f) {
  srand(1)
  print("\n#################### " f)
  f="eg_" f
  @f() }

BEGIN{
  eg("tab1")
  eg("tab2")
  eg("tab3")
  rogues()}
