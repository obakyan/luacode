local mfl, mce = math.floor, math.ceil

-- Bezout equation
-- solve a * x + b * y = 1
-- return value is x, y
-- gcd(a, b) should be 1
local function bezout_eq(a, b)
  if b == 0 then
    return 1, 0
  end
  local y, x = bezout_eq(b, a % b)
  y = y - mfl(a / b) * x
  return x, y
end

-- 5x + 12y = 1
-- x = 5, y = -2
print(bezout_eq(5, 12))
-- x = -2, y = 5
print(bezout_eq(12, 5))


-- Linear, but not good performance
local function getprimes2(x)
  local primes = {}
  local lp = {}
  for i = 1, x do lp[i] = false end
  for i = 2, x do
    if not lp[i] then
      table.insert(primes, i)
      lp[i] = i
    end
    for j = 1, #primes do
      local p = primes[j]
      if x < p * i or lp[i] < p then break end
      lp[p * i] = p
    end
  end
  return primes
end
