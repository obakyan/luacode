package.path = package.path .. ';./../avltree.lua'
local AvlTree = require("avltree")
-- test
print(os.clock())
local n = 200000
local function z(x, y) return x < y end
local a = AvlTree.new(function(x, y) return x < y end, n)
-- local a = AvlTree.new(z, n)
print(os.clock())
for i = 1, n do a:add(i) end
print(os.clock())
for i = 1, n do a:pop() end
print(os.clock())
