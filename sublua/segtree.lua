local mfl, mce, mmi = math.floor, math.ceil, math.min
local SegTree = {}
SegTree.updateAll = function(self)
  for i = self.stagenum - 1, 1, -1 do
    for j = 1, self.cnt[i] do
      self.stage[i][j] = self.func(self.stage[i + 1][j * 2 - 1], self.stage[i + 1][j * 2])
    end
  end
end
SegTree.create = function(self, ary, func, emptyvalue)
  self.func, self.emptyvalue = func, emptyvalue
  local stagenum, mul = 1, 1
  self.cnt, self.stage, self.size = {1}, {{}}, {}
  while mul < #ary do
    mul, stagenum = mul * 2, stagenum + 1
    self.cnt[stagenum], self.stage[stagenum] = mul, {}
  end
  for i = 1, stagenum do self.size[i] = self.cnt[stagenum + 1 - i] end
  self.stagenum = stagenum
  for i = 1, #ary do self.stage[stagenum][i] = ary[i] end
  for i = #ary + 1, mul do self.stage[stagenum][i] = emptyvalue end
  self:updateAll()
end
SegTree.getRange = function(self, left, right)
  if left == right then return self.stage[self.stagenum][left] end
  local start_stage = 1
  while right - left + 1 < self.size[start_stage] do
    start_stage = start_stage + 1
  end
  local ret = self.emptyvalue
  local tasks = {{start_stage, left, right}}
  while 0 < #tasks do
    local task = tasks[#tasks]
    table.remove(tasks)
    local stage, l, r = task[1], task[2], task[3]
    local sz = self.size[stage]
    if (l - 1) % sz ~= 0 then
      local newr = mce((l - 1) / sz) * sz
      table.insert(tasks, {stage + 1, l, mmi(r, newr)})
      l = newr + 1
    end
    if sz <= r + 1 - l then
      local pos = mce(l / sz)
      ret = self.func(ret, self.stage[stage][pos])
      l = l + sz
    end
    if l <= r then
      table.insert(tasks, {stage + 1, l, r})
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
SegTree.new = function(ary, func, emptyvalue)
  local obj = {}
  setmetatable(obj, {__index = SegTree})
  obj:create(ary, func, emptyvalue)
  return obj
end

-- TEST
local test = SegTree.new({1, 2, 3, 4, 5}, function(a, b) return a + b end, 0)
for i = 1, 5 do
  for j = i, 5 do
    print(i, j, test:getRange(i, j))
  end
end
print("---")
test:setValue(3, 10)
for i = 1, 5 do
  for j = i, 5 do
    print(i, j, test:getRange(i, j))
  end
end
