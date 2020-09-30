local mfl, mce = math.floor, math.ceil
local msq = math.sqrt
local bls, brs = bit.lshift, bit.rshift

local function bmulslow(x, y, mod)
  local x1, y1 = x % 10000, y % 10000
  local x2, y2 = mfl(x / 10000) % 10000, mfl(y / 10000) % 10000
  local x3, y3 = mfl(x / 100000000), mfl(y / 100000000)
  local ret = (x1 * y1 + (x1 * y2 + x2 * y1) * 10000) % mod
  ret = (ret + (x1 * y3 + x2 * y2 + x3 * y1) * 10000 % mod * 10000 % mod) % mod
  ret = (ret + (x2 * y3 + x3 * y2) * 10000 % mod * 10000 % mod * 10000) % mod
  ret = (ret +  x3 * y3 * 10000 % mod * 10000 % mod * 10000 % mod * 10000) % mod
  return ret
end

local function getprimes(x)
  local primes = {}
  local allnums = {}
  for i = 1, x do allnums[i] = true end
  for i = 2, x do
    if allnums[i] then
      table.insert(primes, i)
      local lim = mfl(x / i)
      for j = 2, lim do
        allnums[j * i] = false
      end
    end
  end
  return primes
end

local function modpow_m(src, pow, mod)
  local res = 1
  while 0 < pow do
    if pow % 2 == 1 then
      res = bmulslow(res, src, mod)
      pow = pow - 1
    end
    src = bmulslow(src, src, mod)
    pow = mfl(pow / 2)
  end
  return res
end
local function modinv_m(src, mod)
  return modpow_m(src, mod - 2, mod)
end

local function tfft_coef_detect_helper(size, modlow)
  local n = bls(1, size)
  local primes = getprimes(mce(msq(modlow * 20)))
  local mul = mce(modlow / n)
  local mod = false
  while true do
    local tgt = mul * n + 1
    local isprime = true
    for i = 1, #primes do
      if tgt % primes[i] == 0 then isprime = false break end
    end
    if isprime then mod = tgt break
    else mul = mul + 1
    end
  end
  local hn = bls(1, size - 1)
  local w = false
  for iw = 2, mod - 2 do
    if modpow_m(iw, n, mod) == 1 and modpow_m(iw, hn, mod) ~= 1 then
      w = iw break
    end
  end
  local ninv = modinv_m(n, mod)
  local winv = modinv_m(w, mod)
  return mod, w, ninv, winv
end

local mod, w, ninv, winv = tfft_coef_detect_helper(15, 2147483648)
print(mod, w, ninv, winv)
