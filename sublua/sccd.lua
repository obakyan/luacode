-- Strongly Connected Component Decomposition
local n, m = io.read("*n", "*n")
local edge = {}
local invedge = {}
for i = 1, n do
  edge[i] = {}
  invedge[i] = {}
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

local function SCCD_dfs(src, dfs_way)
  asked[src] = true
  for i = 1, #edge[src] do
    local dst = edge[src][i]
    if not asked[dst] then
      SCCD_dfs(dst, dfs_way)
    end
  end
  table.insert(dfs_way, src)
end

local function SCCD_invdfs(src, rootid)
  sccd_root[src] = rootid
  for i = 1, #invedge[src] do
    local dst = invedge[src][i]
    if asked[dst] and sccd_root[dst] == 0 then
      SCCD_invdfs(dst, rootid)
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
