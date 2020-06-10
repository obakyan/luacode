local MPM = {}

MPM.initialize = function(self, n, spos, tpos)
  self.n = n
  self.spos, self.tpos = spos, tpos
  self.edge_dst = {}
  self.edge_cap = {}
  self.edge_dst_invpos = {}
  self.slen = {}
  self.tlen = {}
  for i = 1, n do
    self.edge_dst[i] = {}
    self.edge_cap[i] = {}
    self.edge_dst_invidx[i] = {}
    self.slen[i], self.tlen[i] = 0, 0
  end
  self.tasks = {}
end

MPM.addEdge = function(self, src, dst, cap)
  table.insert(self.edge_dst[src], dst)
  table.insert(self.edge_cap[src], cap)
  table.insert(self.edge_dst_invidx[src], 1 + #self.edge_dst[dst])
  table.insert(self.edge_dst[dst], src)
  table.insert(self.edge_cap[dst], 0)
  table.insert(self.edge_dst_invidx[dst], #self.edge_dst[src])
end
MPM.updateLength = function(self)
  local inf = self.n + 1
  for i = 1, self.n do
    self.slen[i] = inf
    self.tlen[i] = inf
  end
  self.slen[self.spos] = 0
  local edge_dst = self.edge_dst
  local edge_cap = self.edge_cap
  local tasks = self.tasks
  local taskcnt, done = 1, 0
  tasks[1] = self.spos
  while done < taskcnt do
    done = done + 1
    local src = tasks[done]
    for i = 1, #edge_dst[src] do
      if 0 < edge_cap[src][i] then
        local dst = edge_dst[i]
        if self.slen[dst] == inf then
          self.slen[dst] = self.slen[src] + 1
          taskcnt = taskcnt + 1
          tasks[taskcnt] = dst
        end
      end
    end
  end
  taskcnt, done = 1, 0
  tasks[1] = self.tpos
  while done < taskcnt do
    done = done + 1
    local src = tasks[done]
    for i = 1, #edge_dst[src] do
      if 0 < edge_cap[src][i] then
        local dst = edge_dst[i]
        if self.tlen[dst] == inf then
          self.tlen[dst] = self.tlen[src] + 1
          taskcnt = taskcnt + 1
          tasks[taskcnt] = dst
        end
      end
    end
  end
end
MPM.getMinLenNodes = function(self)
end
