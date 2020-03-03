package.path = package.path .. ';./../avltree.lua'
local AvlTree = require("avltree")
-- test
local t_start = os.clock()
local h, w = 400
local n = 400000
local w = math.floor(n / h)
local n = h * w
local function z(x, y) return x < y end
local a = AvlTree.new(function(x, y) return x < y end, n)
-- local a = AvlTree.new(z, n)
local t_create = os.clock()
print("create " .. t_create - t_start)
-- for i = 1, n do a:push(i) end
for i = 1, h do
  for j = 1, w do
    a:push((j - 1) * h + i)
  end
end
local t_add = os.clock()
print("add    " .. t_add - t_create)
for i = 1, n do a:pop() end
local t_rm = os.clock()
print("remove " .. t_rm - t_add)
