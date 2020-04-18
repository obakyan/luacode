-- Need SegTree: setValue, getRange
local n = io.read("*n")
local edge = {}
local asked = {}
local cpos = {}
local len = {}
local stpos = {}
for i = 1, n do
  edge[i] = {}
  asked[i] = false
  cpos[i] = 0
  len[i] = 0
  stpos[i] = 0
end
len[n + 1] = 1000000007
for i = 1, n - 1 do
  local x, y = io.read("*n", "*n")
  table.insert(edge[x], y)
  table.insert(edge[y], x)
end
local st = SegTree.new(2 * n - 1, function(a, b) return len[a] < len[b] and a or b end, n + 1)

local tasks = {1}
local sti = 1
while 0 < #tasks do
  local src = tasks[#tasks]
  table.remove(tasks)
  asked[src] = true
  -- print(src, len[src])
  stpos[src] = sti
  st:setValue(sti, src, true)
  sti = sti + 1
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
st:updateAll()
