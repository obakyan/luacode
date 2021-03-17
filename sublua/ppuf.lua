local mfl, mce = math.floor, math.ceil
-- Partially Persistent Union-Find
local PPUF = {}
PPUF.create = function(self, n, inf)
  if not inf then inf = 1000000007 end
  self.inf = inf
  self.parent = {}
  self.updated_time = {}
  self.rank = {}
  self.weight_change_time = {}
  self.weight = {}
  for i = 1, n do
    self.parent[i] = 0
    self.updated_time[i] = inf
    self.rank[i] = 1
    self.weight_change_time[i] = {0}
    -- change weight if need
    self.weight[i] = {1}
  end
  self.edgecnt = 0
end

PPUF.getRoot = function(self, v, tm)
  if not tm then tm = self.edgecnt end
  while self.updated_time[v] <= tm do
    v = self.parent[v]
  end
  return v
end

PPUF.unite = function(self, v1, v2)
  local r1, r2 = self:getRoot(v1), self:getRoot(v2)
  local ec = self.edgecnt + 1
  self.edgecnt = ec
  if r1 == r2 then return end
  if self.rank[r2] < self.rank[r1] then r1, r2 = r2, r1 end
  self.parent[r1] = r2
  self.updated_time[r1] = ec
  local weight = self.weight
  local new_w = weight[r2][#weight[r2]] + weight[r1][#weight[r1]]
  table.insert(self.weight_change_time[r2], ec)
  table.insert(weight[r2], new_w)
end

PPUF.getWeight = function(self, v, tm)
  if not tm then tm = self.edgecnt end
  local r = self:getRoot(v, tm)
  local wct = self.weight_change_time[r]
  if wct[#wct] <= tm then return self.weight[r][#wct] end
  local left, right = 1, #wct
  while 1 < right - left do
    local mid = mfl((left + right) / 2)
    if wct[mid] <= tm then
      left = mid
    else
      right = mid
    end
  end
  return self.weight[r][left]
end

PPUF.new = function()
  local obj = {}
  setmetatable(obj, {__index = PPUF})
  return obj
end

--
return PPUF
