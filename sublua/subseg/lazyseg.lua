local mfl, mce, mmi = math.floor, math.ceil, math.min
local mma = math.max
local LazySegTree = {}

LazySegTree.create = function(self, n, func, emptyvalue)
  self.emptyvalue = emptyvalue
  self.func = func
  local stagenum, mul = 1, 1
  self.cnt, self.size = {1}, {}
  self.lazy = {{emptyvalue}}
  while mul < n do
    mul, stagenum = mul * 2, stagenum + 1
    self.cnt[stagenum] = mul
    self.lazy[stagenum] = {}
    for i = 1, mul do self.lazy[stagenum][i] = emptyvalue end
  end
  for i = 1, stagenum do self.size[i] = self.cnt[stagenum + 1 - i] end
  self.stagenum = stagenum
end
LazySegTree.resolveAll = function(self)
  for stage = 1, self.stagenum - 1 do
    for pos = 1, self.cnt[stage] do
      local v = self.lazy[stage][pos]
      if v ~= self.emptyvalue then
        self.lazy[stage + 1][pos * 2 - 1] = self.func(self.lazy[stage + 1][pos * 2 - 1], v)
        self.lazy[stage + 1][pos * 2] = self.func(self.lazy[stage + 1][pos * 2], v)
        self.lazy[stage][pos] = self.emptyvalue
      end
    end
  end
  return self.lazy[self.stagenum]
end
LazySegTree.getValue = function(self, idx)
  for stage = 1, self.stagenum - 1 do
    local pos = mce(idx / (self.size[stage]))
    local v = self.lazy[stage][pos]
    if v ~= self.emptyvalue then
      self.lazy[stage + 1][pos * 2 - 1] = self.func(self.lazy[stage + 1][pos * 2 - 1], v)
      self.lazy[stage + 1][pos * 2] = self.func(self.lazy[stage + 1][pos * 2], v)
      self.lazy[stage][pos] = self.emptyvalue
    end
  end
  return self.lazy[self.stagenum][idx]
end
LazySegTree.setRange = function(self, left, right, value)
  if left == right then
    self.lazy[self.stagenum][left] = self.func(self.lazy[self.stagenum][left], value)
    return
  end
  local start_stage = 1
  while right - left + 1 < self.size[start_stage] do
    start_stage = start_stage + 1
  end
  local t1, t2, t3 = {start_stage}, {left}, {right}
  while 0 < #t1 do
    local stage, l, r = t1[#t1], t2[#t1], t3[#t1]
    table.remove(t1) table.remove(t2) table.remove(t3)
    local sz = self.size[stage]
    if (l - 1) % sz ~= 0 then
      local newr = mmi(r, mce((l - 1) / sz) * sz)
      table.insert(t1, stage + 1) table.insert(t2, l) table.insert(t3, newr)
      l = newr + 1
    end
    if sz <= r + 1 - l then
      self.lazy[stage][mce(l / sz)] = self.func(self.lazy[stage][mce(l / sz)], value)
      l = l + sz
    end
    if l <= r then
      table.insert(t1, stage + 1) table.insert(t2, l) table.insert(t3, r)
    end
  end
end
LazySegTree.new = function(n, func, emptyvalue)
  local obj = {}
  setmetatable(obj, {__index = LazySegTree})
  obj:create(n, func, emptyvalue)
  return obj
end

--
return LazySegTree
