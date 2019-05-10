
local mce, mfl, msq, mmi, mma = math.ceil, math.floor, math.sqrt, math.min, math.max

local function getgcd(x, y)
  while(0 < x and 0 < y) do
    if(x < y) then y = y % x else x = x % y end
  end
  return math.max(x, y)
end

local function getxor(x, y)
  local ret = 0
  local mul = 1
  while(0 < x or 0 < y) do
    if((x % 2) + (y % 2) == 1) then
      ret = ret + mul
    end
    x, y, mul = math.floor(x / 2), math.floor(y / 2), mul * 2
  end
  return ret
end

local function getprimes(x)
  local primes = {}
  local allnums = {}
  for i = 1, x do allnums[i] = true end
  for i = 2, x do
    if(allnums[i]) then
      table.insert(primes, i)
      local lim = math.floor(x / i)
      for j = 2, lim do
        allnums[j * i] = false
      end
    end
  end
  return primes
end

-- Lua 5.1 only
local function getdivisorparts(x, primes)
  local prime_num = #primes
  local tmp = {}
  local lim = math.ceil(math.sqrt(x))
  local primepos = 1
  local dv = primes[primepos]
  while(primepos <= prime_num and dv <= lim) do
    if(x % dv == 0) then
      local asdf = {}
      asdf.p = dv
      asdf.cnt = 1
      x = x / dv
      while(x % dv == 0) do
        x = x / dv
        asdf.cnt = asdf.cnt + 1
      end
      table.insert(tmp, asdf)
      lim = math.ceil(math.sqrt(x))
    end
    if(primepos == prime_num) then break end
    primepos = primepos + 1
    dv = primes[primepos]
  end
  if(x ~= 1) then
    local asdf = {}
    asdf.p, asdf.cnt = x, 1
    table.insert(tmp, asdf)
  end
  return tmp
end

local function getpattern(n, patall, idx)
  local used = {}
  local retary = {}
  local div = patall
  for i = 1, n do used[i] = false end
  for i = n, 1, -1 do
    div = math.floor(div / i)
    local v_idx = math.floor(idx / div)
    idx = idx % div
    local tmp_idx = 0
    for j = 1, n do
      if(not used[j]) then
        if(tmp_idx == v_idx) then
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
