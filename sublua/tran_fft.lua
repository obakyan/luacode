-- TRAN FFT
local mfl = math.floor
local TranFFT = {}

TranFFT.initialize = function(self)
  self.size = 18
  -- 2^18
  self.n = 262144
  -- 1007681537: prime,
  -- 1007681537 % 262144 = 1
  self.mod = 1007681537
  -- (6161^262144) % mod = 1
  self.w = 6161
  -- (1007677693 * 262144) % mod = 1
  self.ninv = 1007677693
  -- (534835031 * 6161) % mod = 1
  self.winv = 534835031
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
end

-- (44893^2) % 1007681537 = 18375
-- 1007681537 = 22446 * 44893 + rem(13259)
-- x0, y0 <= 44892
-- x1, y1 <= 22446
-- max(x1y1*18375+(x1y0+x0y1)*44893+x0y0) < 10^14
TranFFT.mul = function(self, x, y)
  local x0, y0 = x % 44893, y % 44893
  local x1, y1 = mfl(x / 44893), mfl(y / 44893)
  return (x1 * y1 * 18375 + (x1 * y0 + x0 * y1) * 44893 + x0 * y0) % self.mod
end

TranFFT.add = function(self, x, y) return (x + y) % self.mod end

TranFFT.fft_common = function(self, ary, wmul)
  local ret = {}
  for i = 1, self.n do
    ret[i] = ary[self.binv[i]]
  end
  for i = 1, self.size do
    local tmpdst = {}
    for j = 1, self.n do
      tmpdst[j] = 0
    end
    local step_size = self.p2[i]
    local step_count = self.p2[self.size + 1 - i]
    for istep = 1, step_count do
      local ofst = (istep - 1) * step_size * 2
      for j = 1, step_size do
        tmpdst[ofst + j] = self:add(ret[ofst + j], self:mul(ret[ofst + step_size + j], wmul[1 + (j - 1) * step_count]))
        tmpdst[ofst + step_size + j] = self:add(ret[ofst + j], self:mul(ret[ofst + step_size + j], wmul[1 + (j + step_size - 1) * step_count]))
      end
    end
    for j = 1, self.n do
      ret[j] = tmpdst[j]
    end
  end
  return ret
end

TranFFT.fft = function(self, ary)
  local wmul = {1}
  for i = 2, self.n do
    wmul[i] = self:mul(wmul[i - 1], self.w)
  end
  return self:fft_common(ary, wmul)
end
TranFFT.ifft = function(self, ary)
  local wmul = {1}
  for i = 2, self.n do
    wmul[i] = self:mul(wmul[i - 1], self.winv)
  end
  local ret = self:fft_common(ary, wmul)
  for i = 1, self.n do
    ret[i] = self:mul(ret[i], self.ninv)
  end
  return ret
end

-- sample (ATC001-C)
TranFFT:initialize()
local a, b = {}, {}
for i = 1, TranFFT.n do
  a[i] = 0
  b[i] = 0
end
local readn = io.read("*n")
for i = 1, readn do
  a[i + 1] = io.read("*n")
  b[i + 1] = io.read("*n")
end

local at = TranFFT:fft(a)
local bt = TranFFT:fft(b)
for i = 1, TranFFT.n do
  at[i] = TranFFT:mul(at[i], bt[i])
end
local c = TranFFT:ifft(at)
for i = 2, 1 + readn * 2 do
  print(c[i])
end
