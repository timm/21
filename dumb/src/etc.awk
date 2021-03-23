# vim: ft=awk ts=2 sw=2 et :
BEGIN {DOT="."
       DOT2=".."
       DOOMED="([ \t]*|#.*$)" }

function red(x)        {   return "\033[31m"x"\033[0m" }
function crash(x)      { print red("E> " x)> "/dev/stderr"; exit 1 }
function List(a)       { split("",a,"") }
function zap(i,k)      { k=k?k:length(i)+1; i[k]["\\"]; delete i[k]["\\"]; return k } 

function has(i,k,f       ) { f=f?f:"List"; k=zap(i,k); @f(i[k]); return k}
function haS(i,k,f,a     ) { f=f?f:"List"; k=zap(i,k); @f(i[k],a); return k}
function hAS(i,k,f,a,b   ) { f=f?f:"List"; k=zap(i,k); @f(i[k],a,b); return k}
function HAS(i,k,f,a,b,c ) { f=f?f:"List"; k=zap(i,k); @f(i[k],a,b,c); return k}

function more(i,f)        { return has(i,"",f) }
function morE(i,f,a)      { return haS(i,"",f,a) }
function moRE(i,f,a,b)    { return hAS(i,"",f,a,b) }
function mORE(i,f,a,b,c)  { return HAS(i,"",f,a.b,c) }

function rogues(    s) {
  for(s in SYMTAB) 
    if (s ~ /^[A-Z][a-z]/) print red("#W> Global " s)>"/dev/stderr"
  for(s in SYMTAB) 
    if (s ~ /^[_a-z]/)     print red("#W> Rogue: " s)>"/dev/stderr" }

function csv(a,file,     j,b4, ok,line,x,y) {
  file  = file ? file : "-"           
  ok = getline < file
  if (ok <0) { crash("missing "file) }
  if (ok==0) { close(file);return 0 }                                    
  line = b4 $0                         
  gsub(DOOMED, "", line)      
  if (!line)       return csv(a,file, line)           
  if (line ~ /,$/) return csv(a,file, line)           
  split(line, a, ",")                  
  return 1 }

function oo(a,prefix,    indent,   i,txt) {
  txt = indent ? indent : (prefix DOT )
  if (!isarray(a)) {print(a); return a}
  for (i in a) {
   PROCINFO["sorted_in"]=typeof(i+1)=="number" ? "@ind_num_asc" : "@ind_str_asc"
   break }
  for(i in a)  
    if (i !~ /^_/)  
      if (isarray(a[i]))   {
        print(txt i"" )
        oo(a[i],"","|  " indent)
      } else
        print(txt i (a[i]==""?"": ": " a[i])) }
