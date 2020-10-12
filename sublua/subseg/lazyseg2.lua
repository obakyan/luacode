-- SetRange and GetRange
-- func: merge function
-- invfunc: devide function(val, numerator, denominator)

local mfl, mce = math.floor, math.ceil
local mmi, mma = math.min, math.max
local bls, brs = bit.lshift, bit.rshift
local LazyRangeSeg = {}
LazyRangeSeg.create = function(self, n, func, invfunc, emptyvalue)
  self.func, self.invfunc, self.emptyvalue = func, invfunc, emptyvalue
  local stagenum, mul = 1, 1
  self.stage = {{emptyvalue}}
  self.lazy = {{0}}
  while mul < n do
    mul, stagenum = mul * 2, stagenum + 1
    self.stage[stagenum] = {}
    self.lazy[stagenum] = {}
    for i = 1, mul do
      self.stage[stagenum][i] = emptyvalue
      self.lazy[stagenum][i] = 0
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
      local incval = self.lazy[i][curidx]
      if 0 < incval then
        incval = self.invfunc(incval, 1, 2)
        self:resolveRange(i + 1, curidx * 2 - 1, incval, true)
        self:resolveRange(i + 1, curidx * 2, incval, true)
        self.lazy[i + 1][curidx * 2 - 1] = self.func(self.lazy[i + 1][curidx * 2 - 1], incval)
        self.lazy[i + 1][curidx * 2] = self.func(self.lazy[i + 1][curidx * 2], incval)
        self.lazy[i][curidx] = self.emptyvalue
      end
    elseif p == right then
      break
    else
      assert(false)
    end
  end
end
LazyRangeSeg.resolveRange = function(self, stagepos, idx, value, shallow)
  self.stage[stagepos][idx] = self.func(self.stage[stagepos][idx], value)
  if shallow then return end
  for i = stagepos - 1, 1, -1 do
    local dst = brs(idx + 1, 1)
    local rem = dst * 4 - 1 - idx
    self.stage[i][dst] = self.func(self.stage[i + 1][idx], self.stage[i + 1][rem])
    idx = dst
  end
end
LazyRangeSeg.resolveAll = function(self)
  for i = 1, self.stagenum - 1 do
    local cnt = bls(1, i - 1)
    for j = 1, cnt do
      local incval = self.lazy[i][j]
      if 0 < incval then
        incval = self.invfunc(incval, 1, 2)
        self:resolveRange(i + 1, j * 2 - 1, incval, true)
        self:resolveRange(i + 1, j * 2, incval, true)
        self.lazy[i + 1][j * 2 - 1] = self.func(self.lazy[i + 1][j * 2 - 1], incval)
        self.lazy[i + 1][j * 2] = self.func(self.lazy[i + 1][j * 2], incval)
        self.lazy[i][j] = self.emptyvalue
      end
    end
  end
end
LazyRangeSeg.getRange = function(self, left, right)
  if 1 < left then self:resolve(left - 1) end
  self:resolve(right)
  local stagenum = self.stagenum
  local ret = self.emptyvalue
  while left <= right do
    local stage = mma(self.left_stage[left], self.sz_stage[right - left + 1])
    local sz = bls(1, stagenum - stage)
    ret = self.func(ret, self.stage[stage][1 + brs(left - 1, stagenum - stage)])
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
    local v = self.invfunc(value, sz, len)
    value = self.invfunc(value, len - sz, len)
    self:resolveRange(stage, idx, v)
    self.lazy[stage][idx] = self.func(self.lazy[stage][idx], v)
    left = left + sz
  end
end

-- lower_bound: experimental
-- accepted at "joisc2010_hideseek"
LazyRangeSeg.lower_bound = function(self, val)
  local ret, retpos = self.emptyvalue, 0
  local stagenum = self.stagenum
  local stage, l, r = 1, 1, bls(1, stagenum - 1)
  while true do
    local sz = bls(1, stagenum - stage)
    self:resolve(l + sz - 1)
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

LazyRangeSeg.addAll = function(self, value)
  self.stage[1][1] = self.stage[1][1] + value * bls(1, self.stagenum - 1)
  self.lazy[1][1] = self.lazy[1][1] + value * bls(1, self.stagenum - 1)
end
LazyRangeSeg.new = function(n, func, invfunc, emptyvalue)
  local obj = {}
  setmetatable(obj, {__index = LazyRangeSeg})
  obj:create(n, func, invfunc, emptyvalue)
  return obj
end

--
return LazyRangeSeg
