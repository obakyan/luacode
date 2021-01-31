-- True-False DP (bitset)
local mfl, mce = math.floor, math.ceil
local bls, brs = bit.lshift, bit.rshift
local bor, band = bit.bor, bit.band
local TFDP = {}

TFDP.initialize = function(self, lim)
  self.lim = lim
  self.sz = 30
  self.way = true
  self.bcnt = mce((lim + 1) / self.sz)
  self.b1, self.b2 = {1}, {}
  for i = 2, self.bcnt do
    self.b1[i] = 0
  end
  self.curmax = 0
end

TFDP.add = function(self, v)
  local src = self.way and self.b1 or self.b2
  local dst = self.way and self.b2 or self.b1
  self.way = not self.way
  local bcnt = self.bcnt
  for i = 1, bcnt do
    dst[i] = src[i]
  end
  local sz = self.sz
  local jump, rem = mfl(v / sz), v % sz
  for i = 1, bcnt - jump do
    local v1 = src[i] % bls(1, sz - rem)
    dst[i + jump] = bor(dst[i + jump], v1 * bls(1, rem))
  end
  for i = 1, bcnt - jump - 1 do
    local v2 = brs(src[i], sz - rem)
    dst[i + jump + 1] = bor(dst[i + jump + 1], v2)
  end
end

TFDP.query = function(self, x)
  local group = mfl(x / self.sz) + 1
  local idx = x - (group - 1) * self.sz
  local tbl = self.way and self.b1 or self.b2
  return band(tbl[group], bls(1, idx)) ~= 0
end

--
return TFDP
