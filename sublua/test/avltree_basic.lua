package.path = package.path .. ';./../avltree.lua'
local AvlTree = require("avltree")

local avl = AvlTree.new(function(x, y) return x < y end, 1)
local rep = 100
math.randomseed(999)
local rnd = math.random
for irep = 1, rep do
  avl:clear()
  local t = {}
  local n = rnd(1000, 2000)
  for i = 1, n do
    local v = rnd(1, 1000000007)
    avl:push(v)
    t[i] = v
  end
  table.sort(t)
  for i = 1, n do
    local v = avl:pop()
    assert(v == t[i])
  end
end
