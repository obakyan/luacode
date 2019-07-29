local SegTree = {}
SegTree.create = function(self, ary, func, emptyvalue)
  self.n = #ary
  self.func = func
  self.emptyvalue = emptyvalue
  self.stagenum = 1
  local mul = 1
  while mul < n do
    mul = mul * 2
    self.stagenum = self.stagenum + 1
  end
  self.stage = {}
  self.stage[1] = {}
  for i = 1, mul do
    self.stage[1][i] = emptyvalue
  end
  for i = 2, self.stage do
    mul = mul / 2
    self.stage[i] = {}
    for j = 1, mul do
      self.stage[i][j] = func(self.stage[i - 1][j * 2 - 1], self.stage[i - 1][j * 2])
    end
  end
end

SegTree.new = function(ary, func, emptyvalue)
  local obj = {}
  setmetatable(obj, {__index = SegTree})
  obj:create(ary, func, emptyvalue)
  return obj
end
