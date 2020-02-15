-- TRAN FFT
local mfl = math.floor
local tran_size = 18
--2^18
local tran_n = 262144
-- 1007681537: prime,
-- 1007681537 % 262144 = 1
local tran_mod = 1007681537
-- (6161^262144) % mod = 1
local tran_w = 6161
-- (1007677693 * 262144) % mod = 1
local tran_ninv = 1007677693
-- (534835031 * 6161) % mod = 1
local tran_winv = 534835031

local tran_p2 = {1}
for i = 2, tran_size do
  tran_p2[i] = tran_p2[i - 1] * 2
end

-- (44893^2) % 1007681537 = 18375
-- 1007681537 = 22446 * 44893 + rem(13259)
-- x0, y0 <= 44892
-- x1, y1 <= 22446
-- max(x1y1*18375+(x1y0+x0y1)*44893+x0y0) < 10^14
local function tran_mul(x, y)
  local x0, y0 = x % 44893, y % 44893
  local x1, y1 = mfl(x / 44893), mfl(y / 44893)
  return (x1 * y1 * 18375 + (x1 * y0 + x0 * y1) * 44893 + x0 * y0) % tran_mod
end

local function tran_add(x, y) return (x + y) % tran_mod end

local function tran_bitinv()
  local inv = {}
  for i = 1, tran_n do
    local y, z = 0, i - 1
    for j = 1, tran_size do
      y = y + (z % 2) * tran_p2[tran_size + 1 - j]
      z = mfl(z / 2)
    end
    inv[i] = y + 1
  end
  return inv
end
local function tran_fft_common(ary, bitinv, wmul)
  local ret = {}
  for i = 1, tran_n do
    ret[i] = ary[bitinv[i]]
  end
  for i = 1, tran_size do
    local tmpdst = {}
    for j = 1, tran_n do
      tmpdst[j] = 0
    end
    local step_size = tran_p2[i]
    local step_count = tran_p2[tran_size + 1 - i]
    for istep = 1, step_count do
      local ofst = (istep - 1) * step_size * 2
      for j = 1, step_size do
        tmpdst[ofst + j] = tran_add(ret[ofst + j], tran_mul(ret[ofst + step_size + j], wmul[1 + (j - 1) * step_count]))
        tmpdst[ofst + step_size + j] = tran_add(ret[ofst + j], tran_mul(ret[ofst + step_size + j], wmul[1 + (j + step_size - 1) * step_count]))
      end
    end
    for j = 1, tran_n do
      ret[j] = tmpdst[j]
    end
  end
  return ret
end
local function tran_fft(ary, bitinv)
  local wmul = {1}
  for i = 2, tran_n do
    wmul[i] = tran_mul(wmul[i - 1], tran_w)
  end
  return tran_fft_common(ary, bitinv, wmul)
end
local function tran_ifft(ary, bitinv)
  local wmul = {1}
  for i = 2, tran_n do
    wmul[i] = tran_mul(wmul[i - 1], tran_winv)
  end
  local ret = tran_fft_common(ary, bitinv, wmul)
  for i = 1, tran_n do
    ret[i] = tran_mul(ret[i], tran_ninv)
  end
  return ret
end

local invs = tran_bitinv()

-- sample
local a, b = {}, {}
for i = 1, tran_n do
  a[i] = 0
  b[i] = 0
end
local n = io.read("*n")
local ofst_a = io.read("*n") - 1
a[1] = io.read("*n")
for i = 2, n do
  local x, y = io.read("*n", "*n")
  a[x - ofst_a] = y
end
local m = io.read("*n")
local ofst_b = io.read("*n") - 1
b[1] = io.read("*n")
for i = 2, m do
  local x, y = io.read("*n", "*n")
  b[x - ofst_b] = y
end

local at = tran_fft(a, invs)
local bt = tran_fft(b, invs)
for i = 1, tran_n do
  at[i] = tran_mul(at[i], bt[i])
end
local c = tran_ifft(at, invs)
local t = {}
for i = 1, tran_n do
  if 0 < c[i] then
    table.insert(t, {i + 1 + ofst_a + ofst_b, c[i]})
  end
end
print(#t)
for i = 1, #t do
  print(t[i][1] .. " " .. t[i][2])
end
