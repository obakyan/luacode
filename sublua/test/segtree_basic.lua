package.path = package.path .. ';./../segtree.lua'
local SegTree = require("segtree")

local test = SegTree.new(5, function(a, b) return a + b end, 0)
for i = 1, 5 do test:setValue(i, i, true) end
test:updateAll()
for i = 1, 5 do
  for j = i, 5 do
    print(i, j, test:getRange(i, j))
  end
end
print("---")
test:setValue(3, 103)
for i = 1, 5 do
  for j = i, 5 do
    print(i, j, test:getRange(i, j))
  end
end
