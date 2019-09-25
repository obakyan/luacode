local mfl, mce, mmi = math.floor, math.ceil, math.min
local SegTree = {}
SegTree.updateAll = function(self)
  for i = self.stagenum - 1, 1, -1 do
    for j = 1, self.cnt[i] do
      self.stage[i][j] = self.func(self.stage[i + 1][j * 2 - 1], self.stage[i + 1][j * 2])
    end
  end
end
SegTree.create = function(self, n, func, emptyvalue)
  self.func, self.emptyvalue = func, emptyvalue
  local stagenum, mul = 1, 1
  self.cnt, self.stage, self.size = {1}, {{}}, {}
  while mul < n do
    mul, stagenum = mul * 2, stagenum + 1
    self.cnt[stagenum], self.stage[stagenum] = mul, {}
  end
  for i = 1, stagenum do self.size[i] = self.cnt[stagenum + 1 - i] end
  self.stagenum = stagenum
  -- for i = 1, #ary do self.stage[stagenum][i] = ary[i] end
  -- for i = #ary + 1, mul do self.stage[stagenum][i] = emptyvalue end
  for i = 1, mul do self.stage[stagenum][i] = emptyvalue end
  self:updateAll()
end
SegTree.getRange = function(self, left, right)
  if left == right then return self.stage[self.stagenum][left] end
  local start_stage = 1
  while right - left + 1 < self.size[start_stage] do
    start_stage = start_stage + 1
  end
  local ret = self.emptyvalue
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
      ret = self.func(ret, self.stage[stage][mce(l / sz)])
      l = l + sz
    end
    if l <= r then
      table.insert(t1, stage + 1) table.insert(t2, l) table.insert(t3, r)
    end
  end
  return ret
end
SegTree.setValue = function(self, idx, value, silent)
  self.stage[self.stagenum][idx] = value
  if not silent then
    for i = self.stagenum - 1, 1, -1 do
      local dst = mce(idx / 2)
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

SegTree.lower_bound = function(self, val)
  local ret, retpos = self.emptyvalue, 0
  local t1, t2, t3 = {1}, {1}, {self.size[1]}
  while 0 < #t1 do
    local stage, l, r = t1[#t1], t2[#t1], t3[#t1]
    table.remove(t1) table.remove(t2) table.remove(t3)
    local sz = self.size[stage]
    if sz <= r + 1 - l then
      local tmp = self.func(ret, self.stage[stage][mce(l / sz)])
      if tmp < val then
        ret, retpos = tmp, l + sz - 1
        if sz ~= 1 then table.insert(t1, stage + 1) table.insert(t2, l + sz) table.insert(t3, r) end
      else
        if sz ~= 1 then table.insert(t1, stage + 1) table.insert(t2, l) table.insert(t3, l + sz - 2) end
      end
    else
      table.insert(t1, stage + 1) table.insert(t2, l) table.insert(t3, r)
    end
  end
  return retpos + 1
end

--
return SegTree
