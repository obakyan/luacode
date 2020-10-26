local SCCD = {}
SCCD.create = function(self, n)
  self.n = n
  self.asked, self.root = {}, {}
  self.edge, self.edge_asked = {}, {}
  self.invedge, self.invedge_asked = {}, {}
  for i = 1, n do
    self.asked[i] = false
    self.root[i] = 0
    self.edge[i] = {}
    self.edge_asked[i] = 0
    self.invedge[i] = {}
    self.invedge_asked[i] = 0
  end
  self.edgeinfo = {}
end
SCCD.addEdge = function(self, src, dst)
  table.insert(self.edge[src], dst)
  table.insert(self.invedge[dst], src)
  table.insert(self.edgeinfo, {src, dst})
end

SCCD.dfs = function(self, spos, dfs_way)
  local asked = self.asked
  local edge, edge_asked = self.edge, self.edge_asked
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

SCCD.invdfs = function(self, spos, rootid)
  local asked, root = self.asked, self.root
  local invedge, invedge_asked = self.invedge, self.invedge_asked
  local tasks = {spos}
  while 0 < #tasks do
    local src = tasks[#tasks]
    root[src] = rootid
    table.remove(tasks)
    while invedge_asked[src] < #invedge[src] do
      invedge_asked[src] = invedge_asked[src] + 1
      local dst = invedge[src][invedge_asked[src]]
      if asked[dst] and root[dst] == 0 then
        table.insert(tasks, src)
        table.insert(tasks, dst)
        break
      end
    end
  end
end

SCCD.categorize = function(self)
  local asked, root = self.asked, self.root
  for src = 1, self.n do
    if not asked[src] then
      local dfs_way = {}
      self:dfs(src, dfs_way)
      for i = #dfs_way, 1, -1 do
        local src = dfs_way[i]
        if root[src] == 0 then
          self:invdfs(src, src)
        end
      end
    end
  end
end


SCCD.make_group_graph = function(self)
  self.gsize = {}
  self.gedge, self.ginvedge = {}, {}
  self.glen = {}
  self.gmember = {}
  local gsize, gmember, glen = self.gsize, self.gmember, self.glen
  local gedge, ginvedge = self.gedge, self.ginvedge
  local root = self.root
  local edgeinfo = self.edgeinfo
  for i = 1, self.n do
    gsize[i] = 0
    gedge[i], ginvedge[i] = {}, {}
    glen[i] = 0
    gmember[i] = {}
  end
  for i = 1, self.n do
    local r = root[i]
    gsize[r] = gsize[r] + 1
    table.insert(gmember[r], i)
  end
  for i = 1, #edgeinfo do
    local a, b = edgeinfo[i][1], edgeinfo[i][2]
    local ra, rb = root[a], root[b]
    if ra ~= rb then
      table.insert(gedge[ra], rb)
      table.insert(ginvedge[rb], ra)
    end
  end
end

SCCD.toposort = function(self)
  self:make_group_graph()
  local gsize, gedge, ginvedge = self.gsize, self.gedge, self.ginvedge
  local topoary = {}
  self.topoary = topoary
  local topo_tasks = {}
  local topo_asked_cnt = {}
  for i = 1, self.n do
    topo_asked_cnt[i] = 0
    if 0 < gsize[i] and #ginvedge[i] == 0 then
      table.insert(topo_tasks, i)
    end
  end
  local topo_done = 0
  while topo_done < #topo_tasks do
    topo_done = topo_done + 1
    local g = topo_tasks[topo_done]
    topoary[topo_done] = g
    for i = 1, #gedge[g] do
      local dst = gedge[g][i]
      topo_asked_cnt[dst] = topo_asked_cnt[dst] + 1
      if topo_asked_cnt[dst] == #ginvedge[dst] then
        table.insert(topo_tasks, dst)
      end
    end
  end
  return topoary
end

SCCD.new = function(n)
  local obj = {}
  setmetatable(obj, {__index = SCCD})
  obj:create(n)
  return obj
end

local n, m = io.read("*n", "*n")
local sccd = SCCD.new(n)
for i = 1, m do
  local a, b = io.read("*n", "*n")
  a, b = a + 1, b + 1
  sccd:addEdge(a, b)
end
sccd:categorize()
local ary = sccd:toposort()
print(#ary)
for i = 1, #ary do
  local r = ary[i]
  io.write(#sccd.gmember[r])
  for j = 1, #sccd.gmember[r] do
    io.write(" " .. sccd.gmember[r][j] - 1)
  end
  io.write("\n")
end
