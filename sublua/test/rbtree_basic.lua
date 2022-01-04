package.path = package.path .. ';./../rbtree.lua'
local RBTree = require("rbtree")

local rb = RBTree.new(100000)
local rep = 50
math.randomseed(999)
local rnd = math.random
for irep = 1, rep do
  local t = {}
  local n = rnd(300, 500)
  for i = 1, n do
    local v = rnd(1, 1000000007)
    rb:push(v, -v)
    t[i] = v
  end
  table.sort(t)
  for i = n, 1, -1 do
    for j = 1, i do
      local left, lvalue = rb:getLeft(t[j] - 1)
      if t[1] < t[j] then
        assert(left == t[j - 1])
        assert(left + lvalue == 0)
      else
        assert(left == nil)
      end
      local right, rvalue = rb:getRight(t[j] + 1)
      if t[j] < t[i] then
        assert(right == t[j + 1])
        assert(right + rvalue == 0)
      else
        assert(right == nil)
      end
      left, lvalue = rb:getLeft(t[j])
      assert(left == t[j])
      assert(left + lvalue == 0)
      local center, cvalue = rb:access(j)
      assert(t[j] == center)
      assert(center + cvalue == 0)
    end
    local rmpos = rnd(1, i)
    rb:remove(t[rmpos])
    table.remove(t, rmpos)
  end
end
