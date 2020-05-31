package.path = package.path .. ';./../avltree.lua'
local AvlTree = require("avltree")

local mma = math.max
local mfl, mce, mmi = math.floor, math.ceil, math.min

local n = io.read("*n", "*l")
local a = {}
local s = io.read()
for str in s:gmatch("%d+") do
  table.insert(a, tonumber(str))
end
local leftsum = {0}
local avleft = AvlTree.new(function(x, y) return x < y end, n + 1)
for i = 1, n do
  leftsum[1] = leftsum[1] + a[i]
  avleft:push(a[i])
end
for i = 1, n do
  avleft:push(a[i + n])
  leftsum[i + 1] = leftsum[i] + a[i + n] - avleft:pop()
end
local avright = AvlTree.new(function(x, y) return x > y end, n + 1)
local rightsum = {0}
for i = 1, n do
  rightsum[1] = rightsum[1] + a[i + 2 * n]
  avright:push(a[i + 2 * n])
end
for i = 1, n do
  avright:push(a[2 * n + 1 - i])
  rightsum[i + 1] = rightsum[i] + a[2 * n + 1 - i] - avright:pop()
end
local ret = leftsum[1] - rightsum[n + 1]
for i = 2, n + 1 do
  ret = mma(ret, leftsum[i] - rightsum[n + 2 - i])
end
print(ret)
