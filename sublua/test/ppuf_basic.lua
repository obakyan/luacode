package.path = package.path .. ';./../ppuf.lua'
local PPUF = require("ppuf")

local rnd = math.random math.randomseed(556)
local n = 500
local m = 10000
local q = 5000
local ppuf = PPUF.new()
ppuf:create(n)
local e1, e2 = {}, {}
for i = 1, m do
  local a, b = rnd(1, n), rnd(1, n)
  while a == b do a, b = rnd(1, n), rnd(1, n) end
  e1[i], e2[i] = a, b
end

local parent = {{}}
for i = 1, n do parent[1][i] = i end
local normal_find_root = function(v, tm)
  while parent[tm + 1][v] ~= v do
    v = parent[tm + 1][v]
  end
  return v
end
for i = 1, m do
  parent[i + 1] = {}
  for j = 1, n do
    parent[i + 1][j] = parent[i][j]
  end
  local v1 = normal_find_root(e1[i], i - 1)
  local v2 = normal_find_root(e2[i], i - 1)
  parent[i + 1][v2] = v1
  ppuf:unite(e1[i], e2[i])
end

for iq = 1, q do
  local v = rnd(1, n)
  local tm = rnd(1, m)

  local normal_r = normal_find_root(v, tm)
  local ppuf_r = ppuf:getRoot(v, tm)

  local ppuf_r_normal_r = normal_find_root(ppuf_r, tm)
  local normal_r_ppuf_r = ppuf:getRoot(normal_r, tm)

  assert(ppuf_r_normal_r == normal_r)
  assert(ppuf_r == normal_r_ppuf_r)

  local z = 0
  for i = 1, n do
    local pp = normal_find_root(i, tm)
    if normal_r == pp then
      z = z + 1
    end
  end
  assert(ppuf:getWeight(v, tm) == z)
end
