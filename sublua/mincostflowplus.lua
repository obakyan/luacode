local mfl, mce = math.floor, math.ceil
local mmi, mma = math.min, math.max
local pow2 = {1}
for i = 2, 28 do pow2[i] = pow2[i - 1] * 2 end
local SegTree = {}
SegTree.updateAll = function(self)
  for i = self.stagenum - 1, 1, -1 do
    local cnt = pow2[i]
    for j = 0, cnt - 1 do
      self.stage[cnt + j] = self.func(self.stage[(cnt + j) * 2], self.stage[(cnt + j) * 2 + 1])
    end
  end
end
SegTree.create = function(self, n, func, emptyvalue)
  self.func, self.emptyvalue = func, emptyvalue
  local stagenum, mul = 1, 1
  self.stage = {}
  while mul < n do
    mul, stagenum = mul * 2, stagenum + 1
  end
  self.stagenum = stagenum
  for i = 1, mul * 2 - 1 do self.stage[i] = emptyvalue end
  for i = 1, n do self.stage[mul + i - 1] = i end
  self:updateAll()
end
SegTree.update = function(self, idx, force)
  idx = idx + pow2[self.stagenum] - 1
  for i = self.stagenum - 1, 1, -1 do
    local dst = mfl(idx / 2)
    local rem = dst * 4 + 1 - idx
    self.stage[dst] = self.func(self.stage[idx], self.stage[rem])
    if not force and self.stage[dst] ~= self.stage[idx] then break end
    idx = dst
  end
end
SegTree.new = function(n, func, emptyvalue)
  local obj = {}
  setmetatable(obj, {__index = SegTree})
  obj:create(n, func, emptyvalue)
  return obj
end

local MinCostFlowPlus = {}

MinCostFlowPlus.initialize = function(self, n, spos, tpos, inf)
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
  -- potential[i]: "potential" for each node
  self.potential = {}
  for i = 1, n do
    self.edge_dst[i] = {}
    self.edge_cost[i] = {}
    self.edge_cap[i] = {}
    self.edge_initialcap[i] = {}
    self.edge_dst_invedge_idx[i] = {}
    self.len[i] = 0
    self.sub_graph_flag[i] = false
    self.potential[i] = 0
  end
end

MinCostFlowPlus.addEdge = function(self, src, dst, cost, cap)
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
MinCostFlowPlus.invwalk_recursive = function(self)
  local edge_cap, edge_cost = self.edge_cap, self.edge_cost
  local len = self.len
  local sub_graph_flag = self.sub_graph_flag
  local sub_graph_v = self.sub_graph_v
  local sub_graph_edgeidx = self.sub_graph_edgeidx
  local potential = self.potential
  local searched_cnt = {0}
  while true do
    local invsrc = sub_graph_v[self.sub_graph_size]
    if invsrc == self.spos then break end
    local eddsrc = self.edge_dst[invsrc]
    local eddiisrc = self.edge_dst_invedge_idx[invsrc]
    local i = searched_cnt[self.sub_graph_size]
    if i < #eddsrc then
      i = i + 1
      searched_cnt[self.sub_graph_size] = i
      local invdst = eddsrc[i]
      local j = eddiisrc[i]
      if 0 < edge_cap[invdst][j]
      and len[invdst] + edge_cost[invdst][j] + potential[invdst] - potential[invsrc]
        == len[invsrc]
      and not sub_graph_flag[invdst] then
        self.sub_graph_size = self.sub_graph_size + 1
        sub_graph_v[self.sub_graph_size] = invdst
        sub_graph_edgeidx[self.sub_graph_size - 1] = j
        sub_graph_flag[invdst] = true
        searched_cnt[self.sub_graph_size] = 0
      end
    else
      self.sub_graph_size = self.sub_graph_size - 1
    end
  end
end

MinCostFlowPlus.walkDKSeg = function(self)
  local edge_dst, edge_cost, edge_cap = self.edge_dst, self.edge_cost, self.edge_cap
  local len = self.len
  local potential = self.potential
  local n = self.n
  local asked = {}
  for i = 1, n do
    asked[i] = false
  end
  asked[n + 1] = true
  local function mergefunc(x, y)
    if asked[x] then return y
    elseif asked[y] then return x
    else
      return len[x] < len[y] and x or y
    end
  end
  local st = SegTree.new(n, mergefunc, n + 1)
  local function walk(src, dst, cost)
    if len[src] + cost + potential[src] - potential[dst] < len[dst] then
      len[dst] = len[src] + cost + potential[src] - potential[dst]
      st:update(dst)
    end
  end
  for i = 1, n do
    local src = st.stage[1]
    if asked[src] then break end
    if self.inf <= len[src] then break end
    asked[src] = true
    st:update(src, true)
    local eddst, edcap, edcost = edge_dst[src], edge_cap[src], edge_cost[src]
    for i = 1, #eddst do
      if 0 < edcap[i] then
        walk(src, eddst[i], edcost[i])
      end
    end
  end
end

MinCostFlowPlus.makeSubGraph = function(self)
  local inf = self.inf
  local len = self.len
  local n = self.n
  local edge_dst, edge_cap = self.edge_dst, self.edge_cap
  local edge_dst_invedge_idx = self.edge_dst_invedge_idx
  local edge_cost = self.edge_cost
  local sub_graph_v = self.sub_graph_v
  local sub_graph_edgeidx = self.sub_graph_edgeidx
  local sub_graph_flag = self.sub_graph_flag
  local potential = self.potential
  for i = 1, n do
    len[i] = inf
    sub_graph_flag[i] = false
  end
  len[self.spos] = 0

  self:walkDKSeg()

  self.sub_graph_size = 0
  if inf <= len[self.tpos] then
    return 0
  end
  -- restore route (from tpos to spos)
  self.sub_graph_size = 1
  sub_graph_v[1] = self.tpos
  self:invwalk_recursive()
  
  for i = 1, n do
    if potential[i] < self.inf then
      potential[i] = potential[i] + len[i]
    end
  end
  
  local min_capacity = inf
  for i = self.sub_graph_size, 2, -1 do
    local src = sub_graph_v[i]
    local j = sub_graph_edgeidx[i - 1]
    min_capacity = mmi(min_capacity, edge_cap[src][j])
  end
  return min_capacity
end

MinCostFlowPlus.flow = function(self, capacity)
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

MinCostFlowPlus.getMinCostFlow = function(self, amount, invalid)
  local ret = 0
  local cap = self:makeSubGraph()
  while 0 < cap do
    cap = mmi(amount, cap)
    ret = ret + self.potential[self.tpos] * cap
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
-- https://yukicoder.me/problems/no/1301
-- all cost should be plus
local mcf = MinCostFlowPlus
local n = io.read("*n")
local m = io.read("*n")
mcf:initialize(n, 1, n, 1000000007 * 100000)
for i = 1, m do
  local u, v, c, d = io.read("*n", "*n", "*n", "*n")
  mcf:addEdge(u, v, c, 1)
  mcf:addEdge(v, u, c, 1)
  mcf:addEdge(u, v, d, 1)
  mcf:addEdge(v, u, d, 1)
end
print(mcf:getMinCostFlow(2))
