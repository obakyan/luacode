local mfl, mce = math.floor, math.ceil
local mmi, mma = math.min, math.max
local bls, brs = bit.lshift, bit.rshift

local LazyRangeSeg = {}
LazyRangeSeg.create = function(self, n,
  merge, lzmerge, lzdevide, lzapply,
  empty, lzempty)
  self.merge, self.lzmerge = merge, lzmerge
  self.lzdevide, self.lzapply = lzdevide, lzapply
  self.empty, self.lzempty = empty, lzempty
  local stagenum, mul = 1, 1
  self.stage = {{empty}}
  self.lazy = {{lzempty}}
  while mul < n do
    mul, stagenum = mul * 2, stagenum + 1
    self.stage[stagenum] = {}
    self.lazy[stagenum] = {}
    for i = 1, mul do
      self.stage[stagenum][i] = empty
      self.lazy[stagenum][i] = lzempty
    end
  end
  self.left_stage = {}
  for i = 1, n do
    local sp, sz = 1, bls(1, stagenum - 1)
    while(i - 1) % sz ~= 0 do
      sp, sz = sp + 1, brs(sz, 1)
    end
    self.left_stage[i] = sp
  end
  self.sz_stage = {}
  local tmp, sp = 1, stagenum
  for i = 1, n do
    if tmp * 2 == i then tmp, sp = tmp * 2, sp - 1 end
    self.sz_stage[i] = sp
  end
  self.stagenum = stagenum
end
LazyRangeSeg.resolve = function(self, right)
  local stagenum = self.stagenum
  local offset = 0
  for i = 1, stagenum - 1 do
    local p = offset + bls(1, stagenum - i)
    if p < right then
      offset = p
      p = p + bls(1, stagenum - i)
    end
    if right < p then
      local curidx = brs(p, stagenum - i)
      local lzval = self.lazy[i][curidx]
      if lzval ~= self.lzempty then
        local sz = bls(1, stagenum - i - 1)
        lzval = self.lzdevide(lzval, sz, sz * 2)
        self:resolveRange(i + 1, curidx * 2 - 1, lzval, true)
        self:resolveRange(i + 1, curidx * 2, lzval, true)
        self.lazy[i + 1][curidx * 2 - 1] = self.lzmerge(self.lazy[i + 1][curidx * 2 - 1], lzval)
        self.lazy[i + 1][curidx * 2] = self.lzmerge(self.lazy[i + 1][curidx * 2], lzval)
        self.lazy[i][curidx] = self.lzempty
      end
    elseif p == right then
      break
    else
      assert(false)
    end
  end
end
LazyRangeSeg.resolveRange = function(self, stagepos, idx, value, shallow)
  self.stage[stagepos][idx] = self.lzapply(self.stage[stagepos][idx], value)
  if shallow then return end
  for i = stagepos - 1, 1, -1 do
    local dst = brs(idx + 1, 1)
    local rem = dst * 4 - 1 - idx
    self.stage[i][dst] = self.merge(self.stage[i + 1][idx], self.stage[i + 1][rem])
    idx = dst
  end
end
LazyRangeSeg.resolveAll = function(self)
  local stagenum = self.stagenum
  for i = 1, stagenum - 1 do
    local cnt = bls(1, i - 1)
    for j = 1, cnt do
      local lzval = self.lazy[i][j]
      if lzval ~= self.lzempty then
        local sz = bls(1, stagenum - i - 1)
        lzval = self.lzdevide(lzval, sz, sz * 2)
        self:resolveRange(i + 1, j * 2 - 1, lzval, true)
        self:resolveRange(i + 1, j * 2, lzval, true)
        self.lazy[i + 1][j * 2 - 1] = self.lzmerge(self.lazy[i + 1][j * 2 - 1], lzval)
        self.lazy[i + 1][j * 2] = self.lzmerge(self.lazy[i + 1][j * 2], lzval)
        self.lazy[i][j] = self.lzempty
      end
    end
  end
end
LazyRangeSeg.getRange = function(self, left, right)
  if 1 < left then self:resolve(left - 1) end
  self:resolve(right)
  local stagenum = self.stagenum
  local ret = self.empty
  while left <= right do
    local stage = mma(self.left_stage[left], self.sz_stage[right - left + 1])
    local sz = bls(1, stagenum - stage)
    ret = self.merge(ret, self.stage[stage][1 + brs(left - 1, stagenum - stage)])
    left = left + sz
  end
  return ret
end
LazyRangeSeg.setRange = function(self, left, right, value)
  if 1 < left then self:resolve(left - 1) end
  self:resolve(right)
  local stagenum = self.stagenum
  while left <= right do
    local stage = mma(self.left_stage[left], self.sz_stage[right - left + 1])
    local sz = bls(1, stagenum - stage)
    local len = right - left + 1
    local idx = 1 + brs(left - 1, stagenum - stage)
    local v = self.lzdevide(value, sz, len)
    value = self.lzdevide(value, len - sz, len)
    self:resolveRange(stage, idx, v)
    self.lazy[stage][idx] = self.lzmerge(self.lazy[stage][idx], v)
    left = left + sz
  end
end

-- lower_bound: experimental
-- accepted at "joisc2010_hideseek"
LazyRangeSeg.lower_bound = function(self, val)
  local ret, retpos = self.empty, 0
  local stagenum = self.stagenum
  local stage, l, r = 1, 1, bls(1, stagenum - 1)
  while true do
    local sz = bls(1, stagenum - stage)
    self:resolve(l + sz - 1)
    local tmp = self.merge(ret, self.stage[stage][mce(l / sz)])
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

LazyRangeSeg.new = function()
  local obj = {}
  setmetatable(obj, {__index = LazyRangeSeg})
  return obj
end

-- merge(a, b) -> c
-- lzmerge(a_lz, b_lz) -> c_lz
-- lzdevide(a_lz, numer, denom) -> b_lz
-- lzapply(a, b_lz) -> c

-- lzst = LazyRangeSeg.new()
-- lzst:create(n,
--   merge, lzmerge, lzdevide, lzapply,
--   empty, lzempty)
