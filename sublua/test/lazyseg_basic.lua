package.path = package.path .. ';./../subseg/lazyseg2.lua'
local mfl, mce = math.floor, math.ceil
local LazySegTree = require("lazyseg2")

math.randomseed(123)
local n = 100
local function merge(a, b) return a + b end
local function invmerge(val, numer, denom)
  return mfl(val * numer / denom)
end
local lzst = LazySegTree.new(n, merge, invmerge, 0)
local normal = {}
for i = 1, n do
  local v = math.random(1, 3)
  normal[i] = v
  lzst:setRange(i, i, v)
end

local sum = {}

local function check()
  sum[1] = normal[1]
  for i = 2, n do
    sum[i] = sum[i - 1] + normal[i]
  end
  for i = 1, n do
    for j = i, n do
      local v1 = lzst:getRange(i, j)
      local v2 = sum[j]
      if 1 < i then v2 = v2 - sum[i - 1] end
      assert(v1 == v2)
    end
  end
end

for i = 1, 1000 do
  local v = math.random(1, 3)
  local left = math.random(1, n)
  local right = math.random(1, n)
  if right < left then left, right = right, left end
  for j = left, right do
    normal[j] = normal[j] + v
  end
  lzst:setRange(left, right, v * (right - left + 1))
  check()
end
