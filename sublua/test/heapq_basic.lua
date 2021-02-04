package.path = package.path .. ';./../heapq.lua'
local Heapq = require("heapq")

local function f(a, b) return a > b end
local hq = Heapq.new(f)
local rnd = math.random math.randomseed(4126)
local n = 10000
local inf = 123456
local t = {}
for i = 1, n do
  local v = rnd(1, inf)
  hq:push(v)
  t[i] = v
end
table.sort(t, f)
for i = 1, n do
  assert(t[i] == hq:pop())
end
