-- vim: ts=2 sw=2 sts=2 et :
-- testing library routines
-- (c) 2021 Tim Menzies (timm@ieee.org) unlicense.org

package.path = '../src/?.lua;' .. package.path 
local Thing=require("thing")
local Lib=require("lib")
local class=Lib.class

Animal =class(Thing)
Animal.sound = '?'


function Animal:_init(name)
    self.name = name
end

function Animal:speak()
    return self._class.sound..' I am '..self.name
end

Cat = class(Animal)
Cat.sound = 'meow'

felix = Cat('felix')

print(felix:speak())
print(felix)
print(felix._base)
print(Cat.classof(felix))
print(Animal.classof(felix))

assert(felix:speak() == 'meow I am felix')
assert(felix._base == Animal)
assert(Cat.classof(felix))
assert(Animal.classof(felix))
