-- find smallest x where
-- 1 <= x
-- val <= f[left:x]
-- if not exist then return n + 1
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


-- find smallest x where
-- left <= x
-- val <= f[left:x]
-- if not exist then return right + 1
SegTree.right_bound = function(self, val, left, right)
  local ret, retpos = self.emptyvalue, left - 1
  local t1, t2, t3 = {1}, {left}, {right}
  while 0 < #t1 do
    local stage, l, r = t1[#t1], t2[#t1], t3[#t1]
    table.remove(t1) table.remove(t2) table.remove(t3)
    local sz = self.size[stage]
    while (l - 1) % sz ~= 0 or r + 1 - l < sz do
      stage = stage + 1
      sz = self.size[stage]
    end
    local tmp = self.func(ret, self.stage[stage][mce(l / sz)])
    if tmp < val then
      ret, retpos = tmp, l + sz - 1
      if retpos == right then break end
      if l + sz <= r then table.insert(t1, 1) table.insert(t2, l + sz) table.insert(t3, r) end
    else
      if sz ~= 1 then table.insert(t1, stage + 1) table.insert(t2, l) table.insert(t3, l + sz - 2) end
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
  local t1, t2, t3 = {1}, {left}, {right}
  while 0 < #t1 do
    local stage, l, r = t1[#t1], t2[#t1], t3[#t1]
    table.remove(t1) table.remove(t2) table.remove(t3)
    local sz = self.size[stage]
    while r % sz ~= 0 or r + 1 - l < sz do
      stage = stage + 1
      sz = self.size[stage]
    end
    local tmp = self.func(ret, self.stage[stage][mfl(r / sz)])
    if tmp < val then
      ret, retpos = tmp, r - sz + 1
      if l + sz <= r then table.insert(t1, 1) table.insert(t2, l) table.insert(t3, r - sz) end
    else
      if sz ~= 1 then table.insert(t1, stage + 1) table.insert(t2, r - sz + 2) table.insert(t3, r) end
    end
  end
  return retpos - 1
end
