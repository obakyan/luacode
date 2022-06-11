package.path = package.path .. ';./../rbset.lua'
local RBSet = require("rbset")

local rb = RBSet.new(100000)
local rep = 50
math.randomseed(999)
local rnd = math.random
for irep = 1, rep do
  local t = {}
  local n = rnd(300, 500)
  for i = 1, n do
    local v = rnd(1, 1000000007)
    rb:push(v)
    t[i] = v
  end
  table.sort(t)
  for i = n, 1, -1 do
    for j = 1, i do
      local left = rb:getLeft(t[j] - 1)
      if t[1] < t[j] then
        assert(left == t[j - 1])
      else
        assert(left == nil)
        assert(t[j] == rb:getMostLeft())
      end
      local right = rb:getRight(t[j] + 1)
      if t[j] < t[i] then
        assert(right == t[j + 1])
      else
        assert(right == nil)
        assert(t[j] == rb:getMostRight())
      end
      left = rb:getLeft(t[j])
      assert(left == t[j])
    end
    local rmpos = rnd(1, i)
    rb:remove(t[rmpos])
    table.remove(t, rmpos)
  end
end
