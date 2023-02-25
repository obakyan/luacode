package.path = package.path .. ';./../cht_lichao.lua'
local LiChaoTree = require("cht_lichao")

local rnd = math.random math.randomseed(5656)
local n = 500
local function testrnd()
  return rnd(-100000, 100000)
end
local x = {}
for i = 1, n do
  x[i] = testrnd()
end
table.sort(x)
local cht = LiChaoTree.new(n, x)
local a, b = {}, {}
local im = 1

local function getMinRaw(x)
  local canda, candb = a[1], b[1]
  for i = 2, im do
    if a[i] * x + b[i] < canda * x + candb then
      canda, candb = a[i], b[i]
    end
  end
  return canda, candb
end

for i = 1, 500 do
  im = i
  a[i] = testrnd()
  b[i] = testrnd()
  cht:addLine(a[i], b[i])
  for j = 1, n do
    local az, bz = cht:getMinAB(x[j])
    local ar, br = getMinRaw(x[j])
    assert(az * x[j] + bz == ar * x[j] + br)
  end
end
