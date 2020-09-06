-- Strongly Connected Component Decomposition
local n, m = io.read("*n", "*n")
local edge = {}
local edge_asked = {}
local invedge = {}
local invedge_asked = {}
for i = 1, n do
  edge[i] = {}
  edge_asked[i] = 0
  invedge[i] = {}
  invedge_asked[i] = 0
end
local edgeinfo = {}
for i = 1, m do
  local a, b = io.read("*n", "*n")
  edgeinfo[i] = {a, b}
  table.insert(edge[a], b)
  table.insert(invedge[b], a)
end

local asked = {}
local sccd_root = {}
for i = 1, n do
  asked[i] = false
  sccd_root[i] = 0
end

local function SCCD_dfs(spos, dfs_way)
  local tasks = {spos}
  while 0 < #tasks do
    local src = tasks[#tasks]
    asked[src] = true
    table.remove(tasks)
    if edge_asked[src] == #edge[src] then
      table.insert(dfs_way, src)
    else
      table.insert(tasks, src)
      edge_asked[src] = edge_asked[src] + 1
      local dst = edge[src][edge_asked[src]]
      if not asked[dst] then
        table.insert(tasks, dst)
      end
    end
  end
end

local function SCCD_invdfs(spos, rootid)
  local tasks = {spos}
  while 0 < #tasks do
    local src = tasks[#tasks]
    sccd_root[src] = rootid
    table.remove(tasks)
    while invedge_asked[src] < #invedge[src] do
      invedge_asked[src] = invedge_asked[src] + 1
      local dst = invedge[src][invedge_asked[src]]
      if asked[dst] and sccd_root[dst] == 0 then
        table.insert(tasks, src)
        table.insert(tasks, dst)
        break
      end
    end
  end
end

local function SCCD_make()
  for src = 1, n do
    if not asked[src] then
      local dfs_way = {}
      SCCD_dfs(src, dfs_way)
      for i = #dfs_way, 1, -1 do
        local src = dfs_way[i]
        if sccd_root[src] == 0 then
          SCCD_invdfs(src, src)
        end
      end
    end
  end
end

SCCD_make()

local gsize = {}
local gedge, ginvedge = {}, {}
local glen = {}
local gmember = {}
for i = 1, n do
  gsize[i] = 0
  gedge[i], ginvedge[i] = {}, {}
  glen[i] = 0
  gmember[i] = {}
end
for i = 1, n do
  local r = sccd_root[i]
  gsize[r] = gsize[r] + 1
  table.insert(gmember[r], i)
end
for i = 1, m do
  local a, b = edgeinfo[i][1], edgeinfo[i][2]
  local ra, rb = sccd_root[a], sccd_root[b]
  if ra ~= rb then
    table.insert(gedge[ra], rb)
    table.insert(ginvedge[rb], ra)
  end
end
for i = 1, n do
  if 0 < gsize[i] then
    print(i .. " : " .. table.concat(gmember[i], ", "))
    for j = 1, #gedge[i] do
      print("    edge to " .. gedge[i][j])
    end
    for j = 1, #ginvedge[i] do
      print("    edge from " .. ginvedge[i][j])
    end
  end
end
