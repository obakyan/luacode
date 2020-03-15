local mfl, mce = math.floor, math.ceil
local mmi, mma = math.min, math.max
local bls, brs = bit.lshift, bit.rshift
local SegTree = {}
SegTree.updateAll = function(self)
  for i = self.stagenum - 1, 1, -1 do
    local cnt = bls(1, i - 1)
    for j = 1, cnt do
      self.stage[i][j] = self.func(self.parent, self.stage[i + 1][j * 2 - 1], self.stage[i + 1][j * 2])
    end
  end
end
SegTree.create = function(self, parentobj, n, func)
  self.func = func
  self.parent = parentobj
  local stagenum, mul = 1, 1
  self.stage = {{}}
  while mul < n do
    mul, stagenum = mul * 2, stagenum + 1
    self.stage[stagenum] = {}
  end
  self.stagenum = stagenum
  for i = 1, n do self.stage[stagenum][i] = i end
  for i = n + 1, mul do self.stage[stagenum][i] = n + 1 end
  self:updateAll()
end
SegTree.update = function(self, idx)
  for i = self.stagenum - 1, 1, -1 do
    local dst = brs(idx + 1, 1)
    local rem = dst * 4 - 1 - idx
    self.stage[i][dst] = self.func(self.parent, self.stage[i + 1][idx], self.stage[i + 1][rem])
    idx = dst
  end
end
SegTree.new = function(parentobj, n, func)
  local obj = {}
  setmetatable(obj, {__index = SegTree})
  obj:create(parentobj, n, func)
  return obj
end

local DijkstraSeg = {}

DijkstraSeg.pop = function(self)
  local src = self.st.stage[1][1]
  if self.updated[src] then
    self.updated[src] = false
    self.st:update(src)
    return src
  else
    return nil
  end
end

DijkstraSeg.walk = function(self, src, dst, cost)
  if self.len[dst] < 0 or self.len[src] + cost < self.len[dst] then
    self.len[dst] = self.len[src] + cost
    self.updated[dst] = true
    self.st:update(dst)
  end
end

DijkstraSeg.merge = function(self, x, y)
  if not self.updated[x] then return y
  elseif not self.updated[y] then return x
  else return self.len[x] < self.len[y] and x or y
  end
end

DijkstraSeg.create = function(self, n, spos)
  self.updated = {}
  self.len = {}
  for i = 1, n + 1 do
    self.updated[i] = false
    self.len[i] = -1
  end
  self.st = SegTree.new(self, n, self.merge)
  self.len[spos] = 0
  self.updated[spos] = true
  self.st:updateAll()
end

DijkstraSeg.new = function(n, spos)
  local obj = {}
  setmetatable(obj, {__index = DijkstraSeg})
  obj:create(n, spos)
  return obj
end

--
return DijkstraSeg

-- usage
local sdj = DijkstraSeg.new(n, spos)
while true do
  local src = sdj:pop()
  if not src then break end
  for dst, cost in pairs(edge[src]) do
    sdj:walk(src, dst, cost)
  end
end
print(table.concat(sdj.len, " "))
