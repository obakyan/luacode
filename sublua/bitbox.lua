local mfl, mce = math.floor, math.ceil
local bls, brs = bit.lshift, bit.rshift
local bor, band = bit.bor, bit.band
local BITBOX = {}

BITBOX.initialize = function(self, lim)
  self.lim = lim
  self.sz = 30
  self.way = true
  self.bcnt = mce(lim / self.sz)
  self.b1 = {}
  for i = 1, self.bcnt do
    self.b1[i] = 0
  end
  self.curmax = 0
end

BITBOX.set = function(self, x)
  local group = mce(x / self.sz)
  local idx = x - (group - 1) * self.sz
  self.b1[group] = bor(self.b1[group], bls(1, idx - 1))
end

BITBOX.query = function(self, x)
  local group = mce(x / self.sz)
  local idx = x - (group - 1) * self.sz
  return band(self.b1[group], bls(1, idx - 1)) ~= 0
end

--
return BITBOX
