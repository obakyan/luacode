local mmi, mma = math.min, math.max
local MPM = {}

MPM.initialize = function(self, n, spos, tpos)
  self.n = n
  self.spos, self.tpos = spos, tpos
  -- edge_dst[src][i] := dst
  self.edge_dst = {}
  -- edge_cap[src][i] := capacity from src to edge_dst[src][i]
  self.edge_cap = {}
  -- edge_dst_invedge_idx[src][i] := "j" where edge_dst[dst][j] == src
  -- in this case, edge_dst_invedge_idx[dst][j] should be "i".
  self.edge_dst_invedge_idx = {}
  -- level[v] := length from spos. level[spos] := 1
  self.level = {}
  -- level_vertex_count[i] := count of vertexes that levels are i
  self.level_vertex_count = {}
  -- sub_graph_v[i] := list of vertexes that are contained in the sub-graph.
  self.sub_graph_v = {}
  -- sub_graph_size := the size of sub_graph_v.
  -- may not equal to #sub_graph_v (because not cleared).
  self.sub_graph_size = 0
  -- sub_graph_flag[v] := whether to contains the vertex v in the sub-graph or not
  self.sub_graph_flag = {}
  -- send[v] := sum of sendable amount from v to other vertexes in the sub-graph
  self.send = {}
  -- receive[v] := sum of receivable amount toward v from other vertexes in the sub-graph
  self.receive = {}
  -- sub_edge_idxes[src][i] := edge (from v) using in the sub-graph.
  -- for example, if sub_edge_idxes[src][i] is j,
  -- the edge from src to dst (= edge_dst[src][j]) contains in the sub-graph.
  self.sub_edge_idxes = {}
  -- sub_edge_cnt[src] := the size of sub_edge_idxes[src].
  -- may not equal to #sub_edge_idxes[src] (because not cleared).
  self.sub_edge_cnt = {}
  -- sub_invedge_idxes[dst] := edge (to dst) using in the sub-graph.
  -- for example, if sub_invedge_idxes[dst][i] is j,
  -- the src is edge_dst[dst][j], and the edge index (from src to dst) is k := edge_dst_invedge_idx[dst][j].
  -- so edge_dst[src][k] is the edge from src to dst using in the sub-graph.
  self.sub_invedge_idxes = {}
  -- sub_invedge_cnt[dst] := the size of sub_invedge_idxes[dst].
  -- may not equal to #sub_invedge_idxes[dst] (because not cleared).
  self.sub_invedge_cnt = {}
  -- flow_route[v] := [for "flowToT"] whether to contain in the route from weak_vertex to tpos.
  self.flow_route = {}
  -- actual_flow_amount[v] := [for "flowToT"] send amount from v
  self.actual_flow_amount = {}
  for i = 1, n do
    self.edge_dst[i] = {}
    self.edge_cap[i] = {}
    self.edge_dst_invedge_idx[i] = {}
    self.level[i] = 0
    self.level_vertex_count[i] = 0
    self.sub_graph_flag[i] = false
    self.send[i] = 0
    self.receive[i] = 0
    self.sub_edge_idxes[i] = {}
    self.sub_edge_cnt[i] = 0
    self.sub_invedge_idxes[i] = {}
    self.sub_invedge_cnt[i] = 0
    self.flow_route[i] = false
    self.actual_flow_amount[i] = 0
  end
end

MPM.addEdge = function(self, src, dst, cap, invcap)
  if not invcap then invcap = 0 end
  table.insert(self.edge_dst[src], dst)
  table.insert(self.edge_cap[src], cap)
  table.insert(self.edge_dst_invedge_idx[src], 1 + #self.edge_dst[dst])
  table.insert(self.edge_dst[dst], src)
  table.insert(self.edge_cap[dst], invcap)
  table.insert(self.edge_dst_invedge_idx[dst], #self.edge_dst[src])
end
MPM.makeSubGraph = function(self)
  local inf = self.n + 2
  local level, sub_graph_flag = self.level, self.sub_graph_flag
  local edge_dst, edge_cap = self.edge_dst, self.edge_cap
  local edge_dst_invedge_idx = self.edge_dst_invedge_idx
  local send, receive = self.send, self.receive
  local sub_graph_v = self.sub_graph_v
  local sub_edge_idxes, sub_edge_cnt = self.sub_edge_idxes, self.sub_edge_cnt
  local sub_invedge_idxes, sub_invedge_cnt = self.sub_invedge_idxes, self.sub_invedge_cnt
  local level_vertex_count = self.level_vertex_count
  for i = 1, self.n do
    level[i] = inf
    sub_graph_flag[i] = false
    send[i], receive[i] = 0, 0
    sub_edge_cnt[i] = 0
    sub_invedge_cnt[i] = 0
    level_vertex_count[i] = 0
  end
  -- BFS
  level[self.spos] = 1
  local taskcnt, done = 1, 0
  sub_graph_v[1] = self.spos
  local reached = false
  while done < taskcnt do
    done = done + 1
    local src = sub_graph_v[done]
    if src == self.tpos then reached = true break end
    for i = 1, #edge_dst[src] do
      local cap = edge_cap[src][i]
      if 0 < cap then
        local dst = edge_dst[src][i]
        if level[dst] == inf then
          level[dst] = level[src] + 1
          taskcnt = taskcnt + 1
          sub_graph_v[taskcnt] = dst
        end
      end
    end
  end
  if not reached then
    self.sub_graph_size = 0
    return false
  end
  -- restore route
  sub_graph_flag[self.tpos] = true
  local curlevel = level[self.tpos]
  while curlevel == level[sub_graph_v[taskcnt]] do
    taskcnt = taskcnt - 1
  end
  for isrc = taskcnt, 1, -1 do
    local src = sub_graph_v[isrc]
    for i = 1, #edge_dst[src] do
      local dst, cap = edge_dst[src][i], edge_cap[src][i]
      if 0 < cap and sub_graph_flag[dst]
      and level[dst] == level[src] + 1 then
        sub_graph_flag[src] = true
        local edgecnt = sub_edge_cnt[src] + 1
        sub_edge_cnt[src] = edgecnt
        sub_edge_idxes[src][edgecnt] = i
        sub_invedge_cnt[dst] = sub_invedge_cnt[dst] + 1
        sub_invedge_idxes[dst][sub_invedge_cnt[dst]] = edge_dst_invedge_idx[src][i]
        send[src] = send[src] + cap
        receive[dst] = receive[dst] + cap
      end
    end
    if not sub_graph_flag[src] then
      for i = 1, #edge_dst[src] do
        local dst = edge_dst[src][i]
        local cap = edge_cap[src][i]
        if 0 < cap and level[dst] == level[src] + 1 then
          send[src] = send[src] - cap
          receive[dst] = receive[dst] - cap
        end
      end
    end
  end
  -- remove unused vertex from "taskcnt" and set as sub_graph_size
  local nodecnt = 1
  for i = 1, taskcnt do
    local v = sub_graph_v[i]
    if sub_graph_flag[v] then
      sub_graph_v[nodecnt] = v
      local lv = level[v]
      level_vertex_count[lv] = level_vertex_count[lv] + 1
      nodecnt = nodecnt + 1
    end
  end
  if sub_graph_v[nodecnt - 1] == self.tpos then
    nodecnt = nodecnt - 1
  else
    sub_graph_v[nodecnt] = self.tpos
    local lv = level[self.tpos]
    level_vertex_count[lv] = level_vertex_count[lv] + 1
  end
  self.sub_graph_size = nodecnt
  return true
end

MPM.subGraphConnected = function(self)
  local max_level = self.level[self.tpos]
  local level_vertex_count = self.level_vertex_count
  for i = 1, max_level do
    if level_vertex_count[i] <= 0 then return false end
  end
  return true
end

MPM.findWeakVertex = function(self)
  local sub_graph_v = self.sub_graph_v
  local sub_graph_size = self.sub_graph_size
  local send, receive = self.send, self.receive
  local min_vertex = self.spos
  local min_potential = send[min_vertex]
  if receive[self.tpos] < min_potential then
    min_vertex = self.tpos
    min_potential = receive[min_vertex]
  end
  for i = 2, sub_graph_size - 1 do
    local v = sub_graph_v[i]
    local min_v = mmi(send[v], receive[v])
    if min_v < min_potential then
      min_potential, min_vertex = min_v, v
    end
  end
  return min_vertex, min_potential
end

MPM.flowToT = function(self, weak_vertex, potential)
  if weak_vertex == self.tpos then return end
  local edge_dst, edge_cap = self.edge_dst, self.edge_cap
  local edge_dst_invedge_idx = self.edge_dst_invedge_idx
  local sub_graph_v = self.sub_graph_v
  local sub_graph_size = self.sub_graph_size
  local sub_edge_cnt = self.sub_edge_cnt
  local sub_edge_idxes = self.sub_edge_idxes
  local send, receive = self.send, self.receive
  local level = self.level
  local flow_route = self.flow_route
  local actual_flow_amount = self.actual_flow_amount
  local tpos = self.tpos
  for i = 1, sub_graph_size do
    local v = sub_graph_v[i]
    flow_route[v] = false
    actual_flow_amount[v] = 0
  end
  flow_route[weak_vertex] = true
  actual_flow_amount[weak_vertex] = potential
  local max_level = level[tpos]
  for iv = 1, sub_graph_size do
    local src = sub_graph_v[iv]
    local lv = level[src]
    if lv == max_level then break end
    local need_to_send = actual_flow_amount[src]
    if flow_route[src] and 0 < need_to_send then
      send[src] = send[src] - need_to_send
      local sub_edge_idxes_src = sub_edge_idxes[src]
      local dsts, caps, invidxes = edge_dst[src], edge_cap[src], edge_dst_invedge_idx[src]
      local used = 0
      -- use edge in descending order, to remove used edges quickly
      for j = sub_edge_cnt[src], 1, -1 do
        local edgeidx = sub_edge_idxes_src[j]
        local dst, cap = dsts[edgeidx], caps[edgeidx]
        local actual_flow = mmi(cap, need_to_send)
        receive[dst] = receive[dst] - actual_flow
        caps[edgeidx] = caps[edgeidx] - actual_flow
        need_to_send = need_to_send - actual_flow
        flow_route[dst] = true
        actual_flow_amount[dst] = actual_flow_amount[dst] + actual_flow
        local inv_edge_idx = invidxes[edgeidx]
        edge_cap[dst][inv_edge_idx] = edge_cap[dst][inv_edge_idx] + actual_flow
        if caps[edgeidx] == 0 then
          used = used + 1
        end
        if need_to_send == 0 then
          break
        end
      end
      sub_edge_cnt[src] = sub_edge_cnt[src] - used
    end
  end
end

MPM.flowFromS = function(self, weak_vertex, potential)
  if weak_vertex == self.spos then return end
  local edge_dst, edge_cap = self.edge_dst, self.edge_cap
  local edge_dst_invedge_idx = self.edge_dst_invedge_idx
  local sub_graph_v = self.sub_graph_v
  local sub_graph_size = self.sub_graph_size
  local sub_edge_cnt = self.sub_edge_cnt
  local sub_edge_idxes = self.sub_edge_idxes
  local sub_invedge_idxes = self.sub_invedge_idxes
  local sub_invedge_cnt = self.sub_invedge_cnt
  local send, receive = self.send, self.receive
  local level = self.level
  local flow_route = self.flow_route
  local actual_flow_amount = self.actual_flow_amount
  local spos = self.spos
  for i = 1, sub_graph_size do
    local v = sub_graph_v[i]
    flow_route[v] = false
    actual_flow_amount[v] = 0
  end
  flow_route[weak_vertex] = true
  actual_flow_amount[weak_vertex] = potential
  local max_level = level[tpos]
  for iv = sub_graph_size, 1, -1 do
    local dst = sub_graph_v[iv]
    local lv = level[dst]
    if lv == 1 then break end
    local need_to_receive = actual_flow_amount[dst]
    if flow_route[dst] and 0 < need_to_receive then
      receive[dst] = receive[dst] - need_to_receive
      local sub_invedge_idxes_dst = sub_invedge_idxes[dst]
      local srcs = edge_dst[dst]
      local inv_invidxes = edge_dst_invedge_idx[dst]
      -- local dsts, caps, invidxes = edge_dst[src], edge_cap[src], edge_dst_invedge_idx[src]
      local used = 0
      -- use edge in descending order, to remove used edges quickly
      for j = sub_invedge_cnt[dst], 1, -1 do
        local invedgeidx = sub_invedge_idxes_dst[j]
        local src = srcs[invedgeidx]
        local edgeidx = inv_invidxes[invedgeidx]
        assert(edge_dst[src][edgeidx] == dst)
        local cap = edge_cap[src][edgeidx]
        local actual_flow = mmi(cap, need_to_receive)

        send[src] = send[src] - actual_flow
        edge_cap[src][edgeidx] = edge_cap[src][edgeidx] - actual_flow
        need_to_receive = need_to_receive - actual_flow
        flow_route[src] = true
        actual_flow_amount[src] = actual_flow_amount[src] + actual_flow
        edge_cap[dst][invedgeidx] = edge_cap[dst][invedgeidx] + actual_flow
        if edge_cap[src][edgeidx] == 0 then
          used = used + 1
        end
        if need_to_receive == 0 then
          break
        end
      end
      sub_invedge_cnt[dst] = sub_invedge_cnt[dst] - used
    end
  end
end

MPM.updateSubGraph = function(self)
  local sub_graph_v = self.sub_graph_v
  local sub_graph_size = self.sub_graph_size
  local sub_graph_flag = self.sub_graph_flag
  local send, receive = self.send, self.receive
  local spos, tpos = self.spos, self.tpos
  local level = self.level
  local level_vertex_count = self.level_vertex_count
  local sub_edge_idxes = self.sub_edge_idxes
  local sub_edge_cnt = self.sub_edge_cnt
  local edge_dst = self.edge_dst
  local sub_invedge_idxes = self.sub_invedge_idxes
  local sub_invedge_cnt = self.sub_invedge_cnt
  local nodecnt = 0
  for i = 1, sub_graph_size do
    local v = sub_graph_v[i]
    local valid = true
    if v ~= spos and receive[v] <= 0 then valid = false end
    if v ~= tpos and send[v] <= 0 then valid = false end
    if valid then
      local sub_invedge_idxes_v = sub_invedge_idxes[v]
      valid = false
      for j = 1, sub_invedge_cnt[v] do
        local ei = sub_invedge_idxes_v[j]
        local src = edge_dst[v][ei]
        if sub_graph_flag[src] then valid = true break end
      end
    end
    if valid then
      nodecnt = nodecnt + 1
      sub_graph_v[nodecnt] = v
    else
      sub_graph_flag[v] = false
      local lv = level[v]
      level_vertex_count[lv] = level_vertex_count[lv] - 1
    end
  end
  sub_graph_size = nodecnt
  for i = sub_graph_size, 1, -1 do
    local v = sub_graph_v[i]
    local valid = false
    local sub_edge_idxes_v = sub_edge_idxes[v]
    for j = 1, sub_edge_cnt[v] do
      local ei = sub_edge_idxes_v[j]
      local dst = edge_dst[v][ei]
      if sub_graph_flag[dst] then valid = true break end
    end
    if not valid then
      sub_graph_flag[v] = false
      local lv = level[v]
      level_vertex_count[lv] = level_vertex_count[lv] - 1
    end
  end
  nodecnt = 0
  for i = 1, sub_graph_size do
    local v = sub_graph_v[i]
    if sub_graph_v[v] then
      nodecnt = nodecnt + 1
      sub_graph_v[nodecnt] = v
    end
  end
  self.sub_graph_size = nodecnt
end

MPM.partialwork = function(self)
  local sum = 0
  while(self:subGraphConnected()) do
    local weak_vertex, potential = self:findWeakVertex()
    self:flowToT(weak_vertex, potential)
    self:flowFromS(weak_vertex, potential)
    self:updateSubGraph()
    sum = sum + potential
  end
  return sum
end

MPM.getMaxFlow = function(self)
  local ret = 0
  while(self:makeSubGraph()) do
    ret = ret + self:partialwork()
  end
  return ret
end

--
return MPM
