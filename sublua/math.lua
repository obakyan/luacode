local mfl, mce = math.floor, math.ceil

-- Bezout equation
-- solve a * x[1] + b * y[1] = 1
-- return value is x[1], y[1]
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
