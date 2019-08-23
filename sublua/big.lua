local mod = 1000000007
local mfl = math.floor

-- 10^9 + 7 only
-- (31623^2) % 1000000007 = 14122
local function bmul(x, y)
  local x0, y0 = x % 31623, y % 31623
  local x1, y1 = mfl(x / 31623), mfl(y / 31623)
  return (x1 * y1 * 14122 + (x1 * y0 + x0 * y1) * 31623 + x0 * y0) % mod
end

local function badd(x, y)
  return (x + y) % mod
end

local function bsub(x, y)
  return x < y and x - y + mod or x - y
end

-- OBSOLETE
local function bmulslow(x, y)
  local x1, y1 = x % 10000, y % 10000
  local x2, y2 = mfl(x / 10000) % 10000, mfl(y / 10000) % 10000
  local x3, y3 = mfl(x / 100000000), mfl(y / 100000000)
  local ret = (x1 * y1 + (x1 * y2 + x2 * y1) * 10000) % mod
  ret = (ret + (x1 * y3 + x2 * y2 + x3 * y1) * 10000 % mod * 10000 % mod) % mod
  ret = (ret + (x2 * y3 + x3 * y2) * 10000 % mod * 10000 % mod * 10000) % mod
  ret = (ret +  x3 * y3 * 10000 % mod * 10000 % mod * 10000 % mod * 10000) % mod
  return ret
end

local function modpow(src, pow)
  local res = 1
  while (0 < pow) do
    if (pow % 2 == 1) then
      res = bmul(res, src)
      pow = pow - 1
    end
    src = bmul(src, src)
    pow = mfl(pow / 2)
  end
  return res
end

local function modinv(src)
  return modpow(src, mod - 2)
end

local function getComb(n, k)
  local ret = 1
  for i = 1, k do
    ret = bmul(ret, n + 1 - i)
    ret = bmul(ret, modinv(i))
  end
  return ret
end

local function goldpow(z, r, pow)
  local resz, resr = 1, 0
  while (0 < pow) do
    if (pow % 2 == 1) then
      resz, resr = (bmul(resz, z) + 5 * bmul(resr, r)) % mod, (bmul(resz, r) + bmul(resr, z)) % mod
      pow = pow - 1
    end
    z, r = (bmul(z, z) + 5 * bmul(r, r)) % mod, bmul(2 * z, r)
    pow = mfl(pow / 2)
  end
  return resz;
end
