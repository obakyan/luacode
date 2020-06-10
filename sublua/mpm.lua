local MPM = {}

MPM.initialize = function(self, n, spos, tpos)
  self.n = n
  self.spos, self.tpos = spos, tpos
  self.edge_dst = {}
  self.edge_cap = {}
  self.edge_dst_invidx = {}
  self.len = {}
  self.sub_graph_flag = {}
  for i = 1, n do
    self.edge_dst[i] = {}
    self.edge_cap[i] = {}
    self.edge_dst_invidx[i] = {}
    self.len[i] = 0
    self.sub_graph_flag[i] = false
  end
  self.sub_graph_v = {}
  self.sub_graph_size = 0
  self.send = {}
  self.receive = {}
end

MPM.addEdge = function(self, src, dst, cap)
  table.insert(self.edge_dst[src], dst)
  table.insert(self.edge_cap[src], cap)
  table.insert(self.edge_dst_invidx[src], 1 + #self.edge_dst[dst])
  table.insert(self.edge_dst[dst], src)
  table.insert(self.edge_cap[dst], 0)
  table.insert(self.edge_dst_invidx[dst], #self.edge_dst[src])
end
MPM.makeSubGraph = function(self)
  local inf = self.n + 1
  local len, sub_graph_flag = self.len, self.sub_graph_flag
  local edge_dst, edge_cap = self.edge_dst, self.edge_cap
  local sub_graph_v = self.sub_graph_v
  for i = 1, self.n do
    len[i] = inf
    sub_graph_flag[i] = false
  end
  -- BFS
  len[self.spos] = 0
  local taskcnt, done = 1, 0
  sub_graph_v[1] = self.spos
  local reached = false
  while done < taskcnt do
    done = done + 1
    local src = sub_graph_v[done]
    for i = 1, #edge_dst[src] do
      if 0 < edge_cap[src][i] then
        local dst = edge_dst[src][i]
        if len[dst] == inf then
          len[dst] = len[src] + 1
          taskcnt = taskcnt + 1
          sub_graph_v[taskcnt] = dst
          if dst == self.tpos then reached = true break end
        end
      end
    end
    if reached then break end
  end
  if not reached then
    self.sub_graph_size = 0
    return false
  end
  -- restore route
  sub_graph_flag[self.tpos] = true
  local curlen = len[self.tpos]
  while curlen == len[sub_graph_v[taskcnt]] do
    taskcnt = taskcnt - 1
  end
  for isrc = taskcnt, 1, -1 do
    local src = sub_graph_v[isrc]
    for i = 1, #edge_dst[src] do
      local dst = edge_dst[src][i]
      if 0 < edge_cap[src][i] and sub_graph_flag[dst]
      and len[dst] == len[src] + 1 then
        sub_graph_flag[src] = true break
      end
    end
  end
  -- remove unused vertex
  local nodecnt = 1
  for i = 1, taskcnt do
    local v = sub_graph_v[i]
    if sub_graph_flag[v] then
      sub_graph_v[nodecnt] = v
      nodecnt = nodecnt + 1
    end
  end
  sub_graph_v[nodecnt] = self.tpos
  self.sub_graph_size = nodecnt
  return true
end

MPM.flow = function(self)
  local sub_graph_flag = self.sub_graph_flag
  local edge_dst, edge_cap = self.edge_dst, self.edge_cap
  local sub_graph_v = self.sub_graph_v
  local gsize = self.sub_graph_size
  for i = 1, gsize do
    self.send[i] = 0
    self.receive[i] = 0
  end
  -- update send-receive amount
  for i = 1, gsize do
    local v = sub_graph_v[i]
  end
end

MPM:initialize(7, 1, 7)
MPM:addEdge(1, 2, 1)
MPM:addEdge(1, 3, 2)
MPM:addEdge(2, 4, 1)
MPM:addEdge(3, 5, 3)
MPM:addEdge(3, 6, 3)
MPM:addEdge(4, 5, 1)
MPM:addEdge(5, 7, 1)
MPM:addEdge(6, 7, 2)
print(MPM:makeSubGraph())
