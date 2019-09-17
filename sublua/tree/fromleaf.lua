local n = io.read("*n")
local edge, edgetask = {}, {}
local asked = {}
for i = 1, n do
  edge[i] = {}
  edgetask[i] = 0
  asked[i] = false
end
for i = 1, n - 1 do
  local p, q = io.read("*n", "*n")
  edge[p][q], edge[q][p] = true, true
  edgetask[p] = edgetask[p] + 1
  edgetask[q] = edgetask[q] + 1
end
local tasks = {1}
for i = 2, n do
  if edgetask[i] == 1 then
    table.insert(tasks, i)
  end
end
while 0 < #tasks do
  local src = tasks[#tasks]
  table.remove(tasks)
  asked[src] = true
  local all, whites = 1, 1
  for dst, _u in pairs(edge[src]) do
    if asked[dst] then
      -- child
    else
      -- parent
      edgetask[dst] = edgetask[dst] - 1
      if edgetask[dst] == 1 and dst ~= 1 then
        table.insert(tasks, dst)
      end
    end
  end
end
