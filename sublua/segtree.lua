local mfl, mce, mmi = math.floor, math.ceil, math.min
local SegTree = {}
SegTree.create = function(self, ary, func, emptyvalue)
  self.n, self.func, self.emptyvalue = #ary, func, emptyvalue
  local stagenum, mul = 1, 1
  self.cnt, self.stage, self.size = {1}, {{}}, {}
  while mul < self.n do
    mul, stagenum = mul * 2, stagenum + 1
    self.cnt[stagenum], self.stage[stagenum] = mul, {}
  end
  for i = 1, stagenum do
    self.size[i] = self.cnt[stagenum + 1 - i]
  end
  self.stagenum = stagenum
  for i = 1, self.n do
    self.stage[stagenum][i] = ary[i]
  end
  for i = self.n + 1, mul do
    self.stage[stagenum][i] = emptyvalue
  end
  for i = stagenum - 1, 1, -1 do
    for j = 1, self.cnt[i] do
      self.stage[i][j] = func(self.stage[i + 1][j * 2 - 1], self.stage[i + 1][j * 2])
    end
  end
end
SegTree.getRange = function(self, left, right)
  local ret = self.emptyvalue
  local tasks = {{1, left, right}}
  while 0 < #tasks do
    local task = tasks[#tasks]
    table.remove(tasks)
    local stage, l, r = task[1], task[2], task[3]
    if (l - 1) % self.size[stage] ~= 0 then
      local newr = mce((l - 1) / self.size[stage]) * self.size[stage]
      table.insert(tasks, {stage + 1, l, mmi(r, newr)})
      l = newr + 1
    end
    if self.size[stage] <= r + 1 - l then
      local pos = mce(l / self.size[stage])
      ret = self.func(ret, self.stage[stage][pos])
      l = l + self.size[stage]
    end
    if l <= r then
      table.insert(tasks, {stage + 1, l, r})
    end
  end
  return ret
end

SegTree.new = function(ary, func, emptyvalue)
  local obj = {}
  setmetatable(obj, {__index = SegTree})
  obj:create(ary, func, emptyvalue)
  return obj
end

local test = SegTree.new({1, 2, 3, 4, 5}, function(a, b) return a + b end, 0)
for i = 1, 5 do
  for j = i, 5 do
    print(i, j, test:getRange(i, j))
  end
end
