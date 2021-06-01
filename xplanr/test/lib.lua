-- vim: ts=2 sw=2 sts=2 et;
-- testing library routines

package.path = '../src/?.lua;' .. package.path 
o=require("lib").o
o {1,2,3}
