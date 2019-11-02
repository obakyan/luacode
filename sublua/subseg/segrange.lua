-- getRange from 1 to right
SegTree.getRangeLeft = function(self, right)
  local stage = 1
  while right < self.size[stage] do
    stage = stage + 1
  end
  local ret = self.emptyvalue
  local l, r = 1, right
  while true do
    local sz = self.size[stage]
    ret = self.func(ret, self.stage[stage][mce(l / sz)])
    l = l + sz
    if l <= r then
      local nsize = r + 1 - l
      while nsize < self.size[stage] do
        stage = stage + 1
      end
    else
      break
    end
  end
  return ret
end
