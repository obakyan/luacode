-- find smallest x where
-- 1 <= x
-- val <= f[left:x]
-- if not exist then return n + 1
SegTree.lower_bound = function(self, val)
  local ret, retpos = self.emptyvalue, 0
  local stage, l, r = 1, 1, self.size[1]
  while true do
    local sz = self.size[stage]
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
  local stage, l, r = 1, left, right
  while true do
    local sz = self.size[stage]
    while (l - 1) % sz ~= 0 or r + 1 - l < sz do
      stage = stage + 1
      sz = self.size[stage]
    end
    local tmp = self.func(ret, self.stage[stage][mce(l / sz)])
    if tmp < val then
      ret, retpos = tmp, l + sz - 1
      if retpos == right then break end
      if l + sz <= r then stage, l, r = 1, l + sz, r
      else break end
    else
      if sz ~= 1 then stage, l, r = stage + 1, l, l + sz - 2
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
  while true do
    local sz = self.size[stage]
    while r % sz ~= 0 or r + 1 - l < sz do
      stage = stage + 1
      sz = self.size[stage]
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
