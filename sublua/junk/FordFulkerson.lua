local mmi, mma = math.min, math.max
local FordFulkerson = {}
FordFulkerson.initialize = function(self, n, spos, tpos)
  self.inf = 1000000007
  self.spos = spos
  self.tpos = tpos
  self.n = n
  self.edge = {}
  for i = 1, n do
    self.edge[i] = {}
  end
  self.box = {}
  self.dstbox = {}
  self.costbox = {}
  self.asked = {}
end

FordFulkerson.addEdge = function(self, src, dst, cap, invcap)
  if not invcap then invcap = 0 end
  self.edge[src][dst] = cap
  self.edge[dst][src] = invcap
end

FordFulkerson.flowOne = function(self)
  local edge = self.edge
  local box = self.box
  local dbox = self.dstbox
  local costbox = self.costbox
  local asked = {}--self.asked
  for i = 1, self.n do asked[i] = false end
  box[1] = self.spos
  dbox[1] = next(edge[self.spos])
  costbox[1] = self.inf
  local bpos = 1
  local ret = 0
  while 0 < bpos do
    local src = box[bpos]
    local dst = dbox[bpos]
    asked[src] = true
    if dst then
      if not asked[dst] and 0 < edge[src][dst] then
        local c = mmi(costbox[bpos], edge[src][dst])
        dbox[bpos] = next(edge[src], dst)
        bpos = bpos + 1
        box[bpos] = dst
        dbox[bpos] = next(edge[dst])
        costbox[bpos] = c
        if dst == self.tpos then
          ret = c
          break
        end
      else
        dbox[bpos] = next(edge[src], dst)
      end
    else
      asked[src] = false
      bpos = bpos - 1
    end
  end
  if ret == 0 then return 0 end
  for i = 1, bpos - 1 do
    local src = box[i]
    local dst = box[i + 1]
    edge[src][dst] = edge[src][dst] - ret
    edge[dst][src] = edge[dst][src] + ret
  end
  return ret
end

FordFulkerson.getMaxFlow = function(self)
  local v = 0
  while true do
    local c = self:flowOne()
    if 0 < c then
      v = v + c
    else
      break
    end
  end
  return v
end

-- local ff = FordFulkerson
-- ff:initialize(7, 1, 7)
-- ff:addEdge(1, 2, 1)
-- ff:addEdge(1, 3, 2)
-- ff:addEdge(2, 4, 1)
-- ff:addEdge(3, 5, 3)
-- ff:addEdge(3, 6, 3)
-- ff:addEdge(4, 5, 1)
-- ff:addEdge(5, 7, 1)
-- ff:addEdge(6, 7, 2)
-- assert(3 == ff:getMaxFlow())