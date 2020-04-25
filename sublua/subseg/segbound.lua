-- find smallest x where
-- 1 <= x
-- val <= f[left:x]
-- if not exist then return n + 1
SegTree.lower_bound = function(self, val)
  local ret, retpos = self.emptyvalue, 0
  local stagenum = self.stagenum
  local stage, l, r = 1, 1, bls(1, stagenum - 1)
  while true do
    local sz = bls(1, stagenum - stage)
    local tmp = self.func(ret, self.stage[stage][mce(l / sz)])
    if tmp < val then
      ret, retpos = tmp, l + sz - 1
      if l + sz <= r then stage, l = stage + 1, l + sz
      else break
      end
    else
      if sz ~= 1 then stage, r = stage + 1, l + sz - 2
      else break
      end
    end
  end
  return retpos + 1
end


-- find smallest x where
-- left <= x
-- val <= f[left:x]
-- if not exist then return right + 1
SegTree.right_bound = function(self, val, left, right)
  local ret, retpos = self.emptyvalue, left - 1
  local l, r = left, right
  local stage = mma(self.left_stage[left], self.sz_stage[right - left + 1])
  local stagenum = self.stagenum
  while true do
    local sz = bls(1, stagenum - stage)
    local tmp = self.func(ret, self.stage[stage][mce(l / sz)])
    if tmp < val then
      ret, retpos = tmp, l + sz - 1
      if retpos == right then break end
      if l + sz <= r then
        l = l + sz
        stage = mma(self.left_stage[l], self.sz_stage[r - l + 1])
      else break end
    else
      if sz ~= 1 then stage, r = stage + 1, l + sz - 2
      else break end
    end
  end
  return retpos + 1
end

-- find largest x where
-- x <= right
-- val <= f[x:right]
-- if not exist then return left - 1
SegTree.left_bound = function(self, val, left, right)
  local ret, retpos = self.emptyvalue, right + 1
  local stage, l, r = 1, left, right
  local stagenum = self.stagenum
  while true do
    local sz = bls(1, stagenum - stage)
    while r % sz ~= 0 or r + 1 - l < sz do
      stage = stage + 1
      sz = bls(1, stagenum - stage)
    end
    local tmp = self.func(ret, self.stage[stage][mfl(r / sz)])
    if tmp < val then
      ret, retpos = tmp, r - sz + 1
      if l + sz <= r then stage, l, r = 1, l, r - sz
      else break end
    else
      if sz ~= 1 then stage, l, r = stage + 1, r - sz + 2, r
      else break end
    end
  end
  return retpos - 1
end
