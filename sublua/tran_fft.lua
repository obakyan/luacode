local mfl = math.floor
local TFFT = {}

--[[
n = 2^18 = 262144
mod w ninv winv
998244353 2192 998240545 79695603
1007681537 6161 1007677693 534835031
]]
--[[
multiple memo
1007681537
(44893^2) % 1007681537 = 18375
1007681537 = 22446 * 44893 + rem(13259)
x0, y0 <= 44892
x1, y1 <= 22446
max(x1y1*18375+(x1y0+x0y1)*44893+x0y0) < 10^14
TFFT.mul = function(self, x, y)
  local x0, y0 = x % 44893, y % 44893
  local x1, y1 = mfl(x / 44893), mfl(y / 44893)
  return (x1 * y1 * 18375 + (x1 * y0 + x0 * y1) * 44893 + x0 * y0) % self.mod
end
]]

TFFT.initialize = function(self)
  self.size = 18
  -- 2^18
  self.n = 262144
  self.mod = 998244353
  self.w = 2192
  self.ninv = 998240545
  self.winv = 79695603
  self.p2 = {1}
  for i = 2, self.size do
    self.p2[i] = self.p2[i - 1] * 2
  end
  self.binv = {}
  for i = 1, self.n do
    local y, z = 0, i - 1
    for j = 1, self.size do
      y = y + (z % 2) * self.p2[self.size + 1 - j]
      z = mfl(z / 2)
    end
    self.binv[i] = y + 1
  end
  self.wmul = {1}
  for i = 2, self.n do
    self.wmul[i] = self:mul(self.wmul[i - 1], self.w)
  end
  self.winvmul = {1}
  for i = 2, self.n do
    self.winvmul[i] = self:mul(self.winvmul[i - 1], self.winv)
  end
end

TFFT.mul = function(self, x, y)
  local x0, y0 = x % 31596, y % 31596
  local x1, y1 = mfl(x / 31596), mfl(y / 31596)
  return (x1 * y1 * 62863 + (x1 * y0 + x0 * y1) * 31596 + x0 * y0) % self.mod
end

TFFT.add = function(self, x, y) return (x + y) % self.mod end

TFFT.fft_common = function(self, ary, wmul)
  local ret = {}
  for i = 1, self.n do
    ret[i] = ary[self.binv[i]]
  end
  for i = 1, self.size do
    local step_size = self.p2[i]
    local step_count = self.p2[self.size + 1 - i]
    for istep = 1, step_count do
      local ofst = (istep - 1) * step_size * 2
      for j = 1, step_size do
        local a1, a2 = ret[ofst + j], ret[ofst + step_size + j]
        ret[ofst + j] = self:add(a1, self:mul(a2, wmul[1 + (j - 1) * step_count]))
        ret[ofst + step_size + j] = self:add(a1, self:mul(a2, wmul[1 + (j + step_size - 1) * step_count]))
      end
    end
  end
  return ret
end

TFFT.fft = function(self, ary)
  return self:fft_common(ary, self.wmul)
end
TFFT.ifft = function(self, ary)
  local ret = self:fft_common(ary, self.winvmul)
  for i = 1, self.n do
    ret[i] = self:mul(ret[i], self.ninv)
  end
  return ret
end

-- sample (ATC001-C)
TFFT:initialize()
local a, b = {}, {}
for i = 1, TFFT.n do
  a[i] = 0
  b[i] = 0
end
local readn = io.read("*n")
for i = 1, readn do
  a[i + 1] = io.read("*n")
  b[i + 1] = io.read("*n")
end

local at = TFFT:fft(a)
local bt = TFFT:fft(b)
for i = 1, TFFT.n do
  at[i] = TFFT:mul(at[i], bt[i])
end
local c = TFFT:ifft(at)
for i = 2, 1 + readn * 2 do
  print(c[i])
end
