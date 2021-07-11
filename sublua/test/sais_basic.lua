package.path = package.path .. ';./../sa_is.lua'
local SAIS = require("sa_is")
local rnd = math.random math.randomseed(5656)
local n = 500
local w = 26
local t = {}
local tw = {}
for i = 1, n do
  t[i] = rnd(1, w)
  tw[i] = string.char(t[i] + 96)
end
tw = table.concat(tw)

local sais = SAIS
sais:create(t, n, w)
local sufa = sais.sufa
local sufa_inv = sais.sufa_inv
local lcpa = sais.lcpa
for i = 1, n - 1 do
  local p1 = sufa[i]
  local p2 = sufa[i + 1]
  local s1 = tw:sub(p1, n)
  local s2 = tw:sub(p2, n)
  assert(s1 < s2)
  local lcp = lcpa[i]
  for j = 1, lcp do
    assert(s1:sub(j, j) == s2:sub(j, j))
  end
  if lcp < #s1 and lcp < #s2 then
    assert(s1:sub(lcp + 1, lcp + 1) ~= s2:sub(lcp + 1, lcp + 1))
  end
end
