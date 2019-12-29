local n = io.read("*n")
local edge = {}
local asked = {}
local cpos = {}
local len = {}
for i = 1, n do
  edge[i] = {}
  asked[i] = false
  cpos[i] = 0
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
  while cpos[src] < #edge[src] do
    cpos[src] = cpos[src] + 1
    local dst = edge[src][cpos[src]]
    if not asked[dst] then
      len[dst] = len[src] + 1
      table.insert(tasks, src)
      table.insert(tasks, dst)
      break
    end
  end
end
