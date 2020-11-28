local mmi, mma = math.min, math.max
local MinCostFlow = {}

MinCostFlow.initialize = function(self, n, spos, tpos, inf)
  self.n = n
  self.spos, self.tpos = spos, tpos
  self.inf = inf
  -- edge_dst[src][i] := dst
  self.edge_dst = {}
  -- edge_cost[src][i] := cost from src to edge_dst[src][i]
  self.edge_cost = {}
  -- edge_cap[src][i] := capacity from src to edge_dst[src][i]
  self.edge_cap = {}
  -- initial capacity. corresponding to edge_cap
  self.edge_initialcap = {}
  -- edge_dst_invedge_idx[src][i] := "j" where edge_dst[dst][j] == src
  -- in this case, edge_dst_invedge_idx[dst][j] should be "i".
  self.edge_dst_invedge_idx = {}
  -- len[v] := length from spos. len[spos] := 0
  self.len = {}
  -- sub_graph_flag[v] := temporal flag to restore shortest path
  self.sub_graph_flag = {}
  -- sub_graph_v[i] := list of vertexes that are contained in the sub-graph. from tpos to spos.
  self.sub_graph_v = {}
  -- sub_graph_edgeidx[i] := edge index from sub_graph_v[i + 1] to sub_graph_v[i]
  self.sub_graph_edgeidx = {}
  -- sub_graph_size := the size of sub_graph_v.
  -- may not equal to #sub_graph_v (because not cleared).
  self.sub_graph_size = 0
  for i = 1, n do
    self.edge_dst[i] = {}
    self.edge_cost[i] = {}
    self.edge_cap[i] = {}
    self.edge_initialcap[i] = {}
    self.edge_dst_invedge_idx[i] = {}
    self.len[i] = 0
    self.sub_graph_flag[i] = false
  end
end

MinCostFlow.addEdge = function(self, src, dst, cost, cap)
  table.insert(self.edge_dst[src], dst)
  table.insert(self.edge_cost[src], cost)
  table.insert(self.edge_cap[src], cap)
  table.insert(self.edge_initialcap[src], cap)
  table.insert(self.edge_dst_invedge_idx[src], 1 + #self.edge_dst[dst])
  table.insert(self.edge_dst[dst], src)
  table.insert(self.edge_cost[dst], -cost)
  table.insert(self.edge_cap[dst], 0)--invcap
  table.insert(self.edge_initialcap[dst], 0)--invcap
  table.insert(self.edge_dst_invedge_idx[dst], #self.edge_dst[src])
end
MinCostFlow.invwalk_recursive = function(self, invsrc)
  if invsrc == self.spos then return true end
  local edge_cap, edge_cost = self.edge_cap, self.edge_cost
  local len = self.len
  local sub_graph_flag = self.sub_graph_flag
  local sub_graph_v = self.sub_graph_v
  local sub_graph_edgeidx = self.sub_graph_edgeidx
  local eddsrc = self.edge_dst[invsrc]
  local eddiisrc = self.edge_dst_invedge_idx[invsrc]
  for i = 1, #eddsrc do
    local invdst = eddsrc[i]
    local j = eddiisrc[i]
    if 0 < edge_cap[invdst][j]
    and len[invdst] + edge_cost[invdst][j] == len[invsrc]
    and not sub_graph_flag[invdst] then
      self.sub_graph_size = self.sub_graph_size + 1
      sub_graph_v[self.sub_graph_size] = invdst
      sub_graph_edgeidx[self.sub_graph_size - 1] = j
      sub_graph_flag[invdst] = true
      if self:invwalk_recursive(invdst) then
        return true
      else
        self.sub_graph_size = self.sub_graph_size - 1
      end
    end
  end
  return false
end

MinCostFlow.walkDK = function(self)
  -- Dijkstra-like walk
  local edge_dst, edge_cost, edge_cap = self.edge_dst, self.edge_cost, self.edge_cap
  local len = self.len
  local tasklim = self.n
  if not self.taskstate then
    self.taskstate = {}
    self.tasks = {}
    for i = 1, tasklim do self.taskstate[i] = false end
  end
  local taskstate = self.taskstate
  local tasks = self.tasks
  local tasknum, done = 0, 0
  local function addtask(idx)
    if not taskstate[idx] and idx ~= self.tpos then
      taskstate[idx] = true
      tasknum = tasknum + 1
      local taskidx = tasknum % tasklim
      if taskidx == 0 then taskidx = tasklim end
      tasks[taskidx] = idx
    end
  end
  local function walk(src, dst, cost)
    if len[src] + cost < len[dst] then
      len[dst] = len[src] + cost
      addtask(dst)
    end
  end
  addtask(self.spos)
  while done < tasknum do
    done = done + 1
    local taskidx = done % tasklim
    if taskidx == 0 then taskidx = tasklim end
    local idx = tasks[taskidx]
    taskstate[idx] = false
    local eddst, edcap, edcost = edge_dst[idx], edge_cap[idx], edge_cost[idx]
    for i = 1, #eddst do
      if 0 < edcap[i] then
        walk(idx, eddst[i], edcost[i])
      end
    end
  end
end
MinCostFlow.walkBF = function(self)
  --Bellman-Ford walk
  local edge_dst, edge_cost, edge_cap = self.edge_dst, self.edge_cost, self.edge_cap
  local len = self.len
  local n = self.n
  if not self.updated1 then
    self.updated1 = {}
    self.updated2 = {}
  end
  local updated1, updated2 = self.updated1, self.updated2
  for i = 1, n do
    updated1[i] = false
  end
  updated1[self.spos] = true
  len[self.spos] = 0
  for irp = 1, n do
    local updsrc = irp % 2 == 1 and updated1 or updated2
    local upddst = irp % 2 == 1 and updated2 or updated1
    for i = 1, n do
      upddst[i] = false
    end
    local alldone = true
    for src = 1, n do
      if updsrc[src] then
        local eddst, edcap, edcost = edge_dst[src], edge_cap[src], edge_cost[src]
        for i = 1, #eddst do
          if 0 < edcap[i] then
            local dst = eddst[i]
            local cost = edcost[i]
            if len[src] + cost < len[dst] then
              len[dst] = len[src] + cost
              upddst[dst] = true
              alldone = false
            end
          end
        end
      end
    end
    if alldone then break end
  end
end

MinCostFlow.makeSubGraph = function(self)
  local inf = self.inf
  local len = self.len
  local n = self.n
  local edge_dst, edge_cap = self.edge_dst, self.edge_cap
  local edge_dst_invedge_idx = self.edge_dst_invedge_idx
  local edge_cost = self.edge_cost
  local sub_graph_v = self.sub_graph_v
  local sub_graph_edgeidx = self.sub_graph_edgeidx
  local sub_graph_flag = self.sub_graph_flag
  for i = 1, n do
    len[i] = inf
    sub_graph_flag[i] = false
  end
  len[self.spos] = 0

  -- Bellman-Ford is good, but Dijkstra-like is very fast in some case
  self:walkDK()
  -- self:walkBF()

  self.sub_graph_size = 0
  if inf <= len[self.tpos] then
    return 0
  end
  -- restore route (from tpos to spos)
  self.sub_graph_size = 1
  sub_graph_v[1] = self.tpos
  self:invwalk_recursive(self.tpos)
  local min_capacity = inf
  for i = self.sub_graph_size, 2, -1 do
    local src = sub_graph_v[i]
    local j = sub_graph_edgeidx[i - 1]
    min_capacity = mmi(min_capacity, edge_cap[src][j])
  end
  return min_capacity
end

MinCostFlow.flow = function(self, capacity)
  local edge_dst, edge_cap = self.edge_dst, self.edge_cap
  local edge_dst_invedge_idx = self.edge_dst_invedge_idx
  local sub_graph_v = self.sub_graph_v
  local sub_graph_edgeidx = self.sub_graph_edgeidx
  for i = self.sub_graph_size, 2, -1 do
    local src = sub_graph_v[i]
    local dst = sub_graph_v[i - 1]
    local j = sub_graph_edgeidx[i - 1]
    edge_cap[src][j] = edge_cap[src][j] - capacity
    local k = edge_dst_invedge_idx[src][j]
    edge_cap[dst][k] = edge_cap[dst][k] + capacity
  end
end

MinCostFlow.getMinCostFlow = function(self, amount, invalid)
  local ret = 0
  local cap = self:makeSubGraph()
  while 0 < cap do
    cap = mmi(amount, cap)
    ret = ret + self.len[self.tpos] * cap
    self:flow(cap)
    amount = amount - cap
    if 0 < amount then
      cap = self:makeSubGraph()
    else
      break
    end
  end
  if 0 < amount then return invalid end
  return ret
end

--
return MinCostFlow
