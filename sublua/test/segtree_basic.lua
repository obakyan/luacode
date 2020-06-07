package.path = package.path .. ';./../segtree.lua'
local SegTree = require("segtree")

math.randomseed(123)
local n = 100
local st = SegTree.new(n, function(a, b) return a + b end, 0)
local normal = {}
for i = 1, n do
  local v = math.random(1, 1000)
  normal[i] = v
  st:setValue(i, v, true)
end
st:updateAll()

local sum = {}

local function check()
  sum[1] = normal[1]
  for i = 2, n do
    sum[i] = sum[i - 1] + normal[i]
  end
  for i = 1, n do
    for j = i, n do
      local v1 = st:getRange(i, j)
      local v2 = sum[j]
      if 1 < i then v2 = v2 - sum[i - 1] end
      assert(v1 == v2)
    end
  end
end

for i = 1, n do
  local v = math.random(1, 1000)
  normal[i] = v
  st:setValue(i, v)
  check()
end
