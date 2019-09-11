local n = io.read("*n")
local edge = {}
local asked = {}
local len = {}
for i = 1, n do
  edge[i] = {}
  asked[i] = false
  len[i] = 0
end
for i = 1, n - 1 do
  local x, y = io.read("*n", "*n")
  table.insert(edge[x], y)
  table.insert(edge[y], x)
end

local tasks = {1}
while 0 < #tasks do
  local src = tasks[#tasks]
  table.remove(tasks)
  asked[src] = true
  -- print(src, len[src])
  while 0 < #edge[src] do
    local dst = edge[src][#edge[src]]
    if not asked[dst] then
      len[dst] = len[src] + 1
      table.insert(tasks, src)
      table.insert(tasks, dst)
      table.remove(edge[src])
      break
    else
      table.remove(edge[src])
    end
  end
end
