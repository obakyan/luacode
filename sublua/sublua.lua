local mce, mfl, msq, mmi, mma, mab = math.ceil, math.floor, math.sqrt, math.min, math.max, math.abs

local function getgcd(x, y)
  while 0 < x do
    x, y = y % x, x
  end
  return y
end

-- 5.3
local function getlcm(x, y)
  local gcd = getgcd(x, y)
  return (x // gcd) * y
end

local function getxor(x, y)
  -- for lua5.3
  return x ~ y
  -- for LuaJIT
  return bit.bxor(x, y)
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

local function getdivisorparts(x, primes)
  local prime_num = #primes
  local tmp = {}
  local lim = mce(msq(x))
  local primepos = 1
  local dv = primes[primepos]
  while primepos <= prime_num and dv <= lim do
    if x % dv == 0 then
      local asdf = {}
      asdf.p = dv
      asdf.cnt = 1
      x = x / dv
      while x % dv == 0 do
        x = x / dv
        asdf.cnt = asdf.cnt + 1
      end
      table.insert(tmp, asdf)
      lim = mce(msq(x))
    end
    if primepos == prime_num then break end
    primepos = primepos + 1
    dv = primes[primepos]
  end
  if x ~= 1 then
    local asdf = {}
    asdf.p, asdf.cnt = x, 1
    table.insert(tmp, asdf)
  end
  return tmp
end

local function getdivisor(divisorparts)
  local t = {}
  local pat = 1
  local len = #divisorparts
  local allpat = 1
  for i = 1, len do
    allpat = allpat * (1 + divisorparts[i].cnt)
  end
  for t_i_pat = 0, allpat - 1 do
    local div = allpat
    local i_pat = t_i_pat
    local ret = 1
    for i = 1, len do
      div = mfl(div / (divisorparts[i].cnt + 1))
      local mul = mfl(i_pat / div)
      i_pat = i_pat % div
      for j = 1, mul do
        ret = ret * divisorparts[i].p
      end
    end
    table.insert(t, ret)
  end
  -- table.sort(t)
  return t
end

-- idx is from 0
local function getpattern(n, patall, idx)
  local used = {}
  local retary = {}
  local div = patall
  for i = 1, n do used[i] = false end
  for i = n, 1, -1 do
    div = mfl(div / i)
    local v_idx = mfl(idx / div)
    idx = idx % div
    local tmp_idx = 0
    for j = 1, n do
      if not used[j] then
        if tmp_idx == v_idx then
          table.insert(retary, j)
          used[j] = true
          break
        else
          tmp_idx = tmp_idx + 1
        end
      end
    end
  end
  return retary
end
