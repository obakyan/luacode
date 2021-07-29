local mod = 1000000007
local mfl = math.floor

local function bmul(x, y)
  local x1, y1 = mfl(x / 31623), mfl(y / 31623)
  local x0, y0 = x - x1 * 31623, y - y1 * 31623
  return (x1 * y1 * 14122 + (x1 * y0 + x0 * y1) * 31623 + x0 * y0) % mod
end

local function badd(x, y)
  return (x + y) % mod
end

local function bsub(x, y)
  return x < y and x - y + mod or x - y
end

local function modpow(src, pow)
  local res = 1
  while 0 < pow do
    if pow % 2 == 1 then
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
  local inv = 1
  for i = 1, k do
    ret = bmul(ret, n + 1 - i)
    inv = bmul(inv, i)
  end
  return bmul(ret, modinv(inv))
end

local function getInvs(n)
  local fact = {1}
  local invs = {1}
  local invfact = {1}
  for i = 2, n do
    fact[i] = bmul(fact[i - 1], i)
    invs[i] = bmul(mfl(mod / i), mod - invs[mod % i])
    invfact[i] = bmul(invfact[i - 1], invs[i])
  end
  return invs, invfact
end

local function getComb(n, k)
  if k == 0 or k == n then return 1 end
  return bmul(fact[n], bmul(invfact[k], invfact[n - k]))
end

local function stirling(n, k)
  local ret = 0
  for i = 0, k do
    local v = bmul(modpow(i, n), getComb(k, i))
    if (k - i) % 2 == 0 then
      ret = badd(ret, v)
    else
      ret = bsub(ret, v)
    end
  end
  return bmul(invfact[k], ret)
  -- return ret
end

local function goldpow(z, r, pow)
  local resz, resr = 1, 0
  while 0 < pow do
    if pow % 2 == 1 then
      resz, resr = (bmul(resz, z) + 5 * bmul(resr, r)) % mod, (bmul(resz, r) + bmul(resr, z)) % mod
      pow = pow - 1
    end
    z, r = (bmul(z, z) + 5 * bmul(r, r)) % mod, bmul(2 * z, r)
    pow = mfl(pow / 2)
  end
  return resz;
end

-- for 10^9 + 7
-- (31623^2) % 1000000007 = 14122

local mfl = math.floor
local mod = 1000000007
local half = 500000004
local dlim = 1000000000000000
local function bmul(x, y)
  if x * y < dlim then return (x * y) % mod end
  local x1, y1 = mfl(x / 31623), mfl(y / 31623)
  local x0, y0 = x - x1 * 31623, y - y1 * 31623
  return (x1 * y1 * 14122 + (x1 * y0 + x0 * y1) * 31623 + x0 * y0) % mod
end

-- for 998244353
-- (31596^2) % 998244353 = 62863
local mod = 998244353
local mfl = math.floor
local function bmul(x, y)
  local x0, y0 = x % 31596, y % 31596
  local x1, y1 = mfl(x / 31596), mfl(y / 31596)
  return (x1 * y1 * 62863 + (x1 * y0 + x0 * y1) * 31596 + x0 * y0) % mod
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
