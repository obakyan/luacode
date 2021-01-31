package.path = package.path .. ';./../bitbox.lua'
local BITBOX = require("bitbox")

local bitbox = BITBOX
local rnd = math.random math.randomseed(4126)
local lim = 3 * 1000 * 1000
local n = 30 * 1000
bitbox:initialize(lim)

local memo = {}
for i = 1, lim do
  memo[i] = false
end

for i = 1, n do
  local x = rnd(1, lim)
  memo[x] = true
  bitbox:set(x)
end

for i = 1, lim do
  assert(memo[i] == bitbox:query(i))
end

