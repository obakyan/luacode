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
MinCostFlow.makeSubGraph = function(self)
  local inf = self.inf
  local len = self.len
  local edge_dst, edge_cap = self.edge_dst, self.edge_cap
  local edge_dst_invedge_idx = self.edge_dst_invedge_idx
  local edge_cost = self.edge_cost
  local sub_graph_v = self.sub_graph_v
  local sub_graph_edgeidx = self.sub_graph_edgeidx
  for i = 1, self.n do
    len[i] = inf
  end
  -- Bellman-Ford
  len[self.spos] = 0
  local n = self.n
  for irp = 1, n do
    for src = 1, n do
      for i = 1, #edge_dst[src] do
        local cap = edge_cap[src][i]
        if 0 < cap then
          local dst = edge_dst[src][i]
          local cost = edge_cost[src][i]
          if len[src] + cost < len[dst] then
            len[dst] = len[src] + cost
          end
        end
      end
    end
  end
  if inf <= len[self.tpos] then
    self.sub_graph_size = 0
    return 0
  end
  local min_capacity = inf
  -- restore route (from tpos to spos)
  sub_graph_v[1] = self.tpos
  local graph_size = 1
  while sub_graph_v[graph_size] ~= self.spos do
    local invsrc = sub_graph_v[graph_size]
    for i = 1, #edge_dst[invsrc] do
      local invdst = edge_dst[invsrc][i]
      local j = edge_dst_invedge_idx[invsrc][i]
      if 0 < edge_cap[invdst][j] and len[invdst] + edge_cost[invdst][j] == len[invsrc] then
        min_capacity = mmi(min_capacity, edge_cap[invdst][j])
        graph_size = graph_size + 1
        sub_graph_v[graph_size] = invdst
        sub_graph_edgeidx[graph_size - 1] = j
        break
      end
    end
  end
  self.sub_graph_size = graph_size
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
