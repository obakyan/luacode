local mfl, mce, mmi = math.floor, math.ceil, math.min
local SegTreeLm = {}
SegTreeLm.updateAll = function(self)
  for i = self.stagenum - 1, 1, -1 do
    local c = #self.stage[i]
    for j = 1, c - 1 do
      self.stage[i][j] = self.func(self.stage[i + 1][j * 2 - 1], self.stage[i + 1][j * 2])
    end
    if #self.stage[i + 1] < c * 2 then
      self.stage[i][c] = self.stage[i + 1][c * 2 - 1]
    else
      self.stage[i][c] = self.func(self.stage[i + 1][c * 2 - 1], self.stage[i + 1][c * 2])
    end
  end
end
SegTreeLm.create = function(self, ary, func, emptyvalue)
  self.func, self.emptyvalue = func, emptyvalue
  local datasize = #ary
  local datacount = {}
  while 1 < datasize do
    table.insert(datacount, 1, datasize)
    datasize = mce(datasize / 2)
  end
  table.insert(datacount, 1, 1)
  self.stagenum = #datacount
  self.stage, self.size = {}, {}
  local mul = 1
  for i = 1, self.stagenum do
    self.stage[i] = {}
    for j = 1, datacount[i] do self.stage[i][j] = emptyvalue end
    mul = mul * 2
  end
  for i = 1, self.stagenum do
    mul = mul / 2
    self.size[i] = mul
  end
  for i = 1, #ary do self.stage[self.stagenum][i] = ary[i] end
  self:updateAll()
end
SegTreeLm.getRange = function(self, left, right)
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
SegTreeLm.setValue = function(self, idx, value, silent)
  self.stage[self.stagenum][idx] = value
  if not silent then
    for i = self.stagenum - 1, 1, -1 do
      local dst = mce(idx / 2)
      if idx % 2 == 0 then
        self.stage[i][dst] = self.func(self.stage[i + 1][idx - 1], self.stage[i + 1][idx])
      else
        if #self.stage[i + 1] == idx then
          self.stage[i][dst] = self.stage[i + 1][idx]
        else
          self.stage[i][dst] = self.func(self.stage[i + 1][idx], self.stage[i + 1][idx + 1])
        end
      end
      idx = dst
    end
  end
end
SegTreeLm.new = function(ary, func, emptyvalue)
  local obj = {}
  setmetatable(obj, {__index = SegTreeLm})
  obj:create(ary, func, emptyvalue)
  return obj
end

SegTreeLm.lower_bound = function(self, val)
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

-- TEST
local test = SegTreeLm.new({1, 2, 3, 4, 5}, function(a, b) return a + b end, 0)
for i = 1, 5 do
  for j = i, 5 do
    print(i, j, test:getRange(i, j))
  end
end
print("---\nLB 9: ", test:lower_bound(9))
print("---")
test:setValue(3, 103)
for i = 1, 5 do
  for j = i, 5 do
    print(i, j, test:getRange(i, j))
  end
end
