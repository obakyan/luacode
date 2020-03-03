local mfl, mce = math.floor, math.ceil
local mmi, mma = math.min, math.max
local bls, brs = bit.lshift, bit.rshift
local SegTree = {}
SegTree.updateAll = function(self)
  for i = self.stagenum - 1, 1, -1 do
    local cnt = bls(1, i - 1)
    for j = 1, cnt do
      self.stage[i][j] = self.func(self.stage[i + 1][j * 2 - 1], self.stage[i + 1][j * 2])
    end
  end
end
SegTree.create = function(self, n, func, emptyvalue)
  self.func, self.emptyvalue = func, emptyvalue
  local stagenum, mul = 1, 1
  self.stage = {{}}
  while mul < n do
    mul, stagenum = mul * 2, stagenum + 1
    self.stage[stagenum] = {}
  end
  self.stagenum = stagenum
  for i = 1, mul do self.stage[stagenum][i] = emptyvalue end
  self:updateAll()
end
SegTree.getRange = function(self, left, right)
  if left == right then return self.stage[self.stagenum][left] end
  local stagenum = self.stagenum
  local ret = self.emptyvalue
  while left <= right do
    local stage, sz = 1, bls(1, stagenum - 1)
    local len = right - left + 1
    while (left - 1) % sz ~= 0 or len < sz do
      stage, sz = stage + 1, brs(sz, 1)
    end
    ret = self.func(ret, self.stage[stage][1 + brs(left - 1, stagenum - stage)])
    left = left + sz
  end
  return ret
end
SegTree.setValue = function(self, idx, value, silent)
  self.stage[self.stagenum][idx] = value
  if not silent then
    for i = self.stagenum - 1, 1, -1 do
      local dst = brs(idx + 1, 1)
      local rem = dst * 4 - 1 - idx
      self.stage[i][dst] = self.func(self.stage[i + 1][idx], self.stage[i + 1][rem])
      idx = dst
    end
  end
end
SegTree.new = function(n, func, emptyvalue)
  local obj = {}
  setmetatable(obj, {__index = SegTree})
  obj:create(n, func, emptyvalue)
  return obj
end

--
return SegTree
