package.path = package.path .. ';./../sptable.lua'
local SparseTable = require("sptable")

local mmi, mma = math.min, math.max
local rnd = math.random math.randomseed(5656)
local n = 300
local ary = {}
for i = 1, n do
  ary[i] = rnd(1, 30)
end
local spt = SparseTable.new(n, ary, mmi)
for i = 1, n do
  for j = i, n do
    local v = ary[i]
    for k = i + 1, j do
      v = mmi(v, ary[k])
    end
    assert(v == spt:query(i, j))
  end
end
