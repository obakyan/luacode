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
        self:resolveRange(i + 1, curidx * 2 - 1, incval)
        self:resolveRange(i + 1, curidx * 2, incval)
        self.lazy[i + 1][curidx * 2 - 1] = self.func(self.lazy[i + 1][curidx * 2 - 1], incval)
        self.lazy[i + 1][curidx * 2] = self.func(self.lazy[i + 1][curidx * 2], incval)
      end
      self.lazy[i][curidx] = self.emptyvalue
    elseif p == right then
      break
    else
      assert(false)
    end
  end
end
LazyRangeSeg.resolveRange = function(self, stagepos, idx, value)
  self.stage[stagepos][idx] = self.func(self.stage[stagepos][idx], value)
  for i = stagepos - 1, 1, -1 do
    local dst = brs(idx + 1, 1)
    local rem = dst * 4 - 1 - idx
    self.stage[i][dst] = self.func(self.stage[i + 1][idx], self.stage[i + 1][rem])
    idx = dst
  end
end
LazyRangeSeg.getRange = function(self, left, right)
  if 1 < left then self:resolve(left - 1) end
  self:resolve(right)
  local stagenum = self.stagenum
  local ret = self.emptyvalue
  while left <= right do
    local stage, sz = 1, bls(1, stagenum - 1)
    local len = right - left + 1
    while (left - 1) % sz ~= 0 or len < sz do
      stage, sz = stage + 1, brs(sz, 1)
    end
    ret = self.func(ret, self.stage[stage][1 + brs(left - 1, stagenum - stage)])
    left = left + sz
  end
  return ret
end
LazyRangeSeg.setRange = function(self, left, right, value)
  local stagenum = self.stagenum
  while left <= right do
    local stage, sz = 1, bls(1, stagenum - 1)
    local len = right - left + 1
    while (left - 1) % sz ~= 0 or len < sz do
      stage, sz = stage + 1, brs(sz, 1)
    end
    local idx = 1 + brs(left - 1, stagenum - stage)
    local v = self.invfunc(value, sz, len)
    value = self.invfunc(value, len - sz, len)
    self:resolveRange(stage, idx, v)
    self.lazy[stage][idx] = self.func(self.lazy[stage][idx], v)
    left = left + sz
  end
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
