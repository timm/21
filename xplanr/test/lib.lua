-- vim: ts=2 sw=2 sts=2 et;
-- testing library routines
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

package.path = '../src/?.lua;' .. package.path 
o=require("lib").o
o {1,2,3}
