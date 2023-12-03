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
  self.left_stage = {}
  for i = 1, n do
    local sp, sz = 1, bls(1, stagenum - 1)
    while(i - 1) % sz ~= 0 do
      sp, sz = sp + 1, brs(sz, 1)
    end
    self.left_stage[i] = sp
  end
  self.sz_stage = {}
  local tmp, sp = 1, stagenum
  for i = 1, n do
    if tmp * 2 == i then tmp, sp = tmp * 2, sp - 1 end
    self.sz_stage[i] = sp
  end
  for i = 1, mul do self.stage[stagenum][i] = emptyvalue end
  self:updateAll()
end
SegTree.getRange = function(self, left, right)
  if left == right then return self.stage[self.stagenum][left] end
  local stagenum = self.stagenum
  local ret = self.emptyvalue
  while left <= right do
    local stage = mma(self.left_stage[left], self.sz_stage[right - left + 1])
    local sz = bls(1, stagenum - stage)
    ret = self.func(ret, self.stage[stage][1 + brs(left - 1, stagenum - stage)])
    left = left + sz
  end
  return ret
end
SegTree.update = function(self, idx)
  local st = self.stage
  for i = self.stagenum - 1, 1, -1 do
    local dst = brs(idx + 1, 1)
    local rem = dst * 4 - 1 - idx
    if rem < idx then rem, idx = idx, rem end
    local v = self.func(st[i + 1][idx], st[i + 1][rem])
    if v == st[i][dst] then
      break
    else
      st[i][dst] = v
      idx = dst
    end
  end
end
SegTree.setValue = function(self, idx, value, silent)
  self.stage[self.stagenum][idx] = value
  if not silent then
    self:update(idx)
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
