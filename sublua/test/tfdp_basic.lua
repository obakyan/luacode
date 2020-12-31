package.path = package.path .. ';./../tfdp.lua'
local TFDP = require("tfdp")

local tfdp = TFDP
local rnd = math.random math.randomseed(4126)
local lim = 10000
local n = 100
local randmax = 100
tfdp:initialize(lim)
local dp = {}
for i = 1, lim do
  dp[i] = false
end
for i = 1, n do
  local v = rnd(1, randmax)
  tfdp:add(v)
  for j = lim - v, 1, -1 do
    if dp[j] then dp[j + v] = true end
  end
  dp[v] = true
end

assert(tfdp:query(0))
for i = 1, lim do
  assert(dp[i] == tfdp:query(i), i)
end
