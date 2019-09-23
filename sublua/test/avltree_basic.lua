package.path = package.path .. ';./../avltree.lua'
local AvlTree = require("avltree")
-- test
local a = AvlTree.new(function(x, y) return x < y end, 32)
-- for i = 15, 1, -1 do a:add(i) end
for i = 1, 15 do a:add(i) end
local function dumptest()
  print("--- dump ---")
  local tasks = {a.root}
  local done = 0
  while done < #tasks do
    done = done + 1
    local node = tasks[done]
    if 1 < a.p[node] then
      print(a.v[a.p[node]] .. "_" .. a.v[node])
    else
      print(a.v[node])
    end
    print("  " .. a.lc[node] .. " " .. a.rc[node])
    if 1 < a.l[node] then table.insert(tasks, a.l[node]) end
    if 1 < a.r[node] then table.insert(tasks, a.r[node]) end
  end
end
dumptest()
print("--- pop ---")
for i = 1, 8 do
  print(a:pop())
end
dumptest()
