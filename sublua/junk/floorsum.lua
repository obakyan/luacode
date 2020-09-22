-- 5.3
-- Sum_{i=0}^{n-1} floor{(a * i + b) / m}
local function floorSum(n, m, a, b)
  local ans = 0
  while true do
    if m <= a then
      ans = ans + ((n - 1) * n // 2) * (a // m)
      a = a % m
    end
    if m <= b then
      ans = ans + n * (b // m)
      b = b % m
    end
    local ymax = (a * n + b) // m
    local xmax = ymax * m - b
    if ymax == 0 then break end
    ans = ans + (n - (xmax + a - 1) // a) * ymax
    n, m, a, b = ymax, a, m, (a - xmax % a) % a
  end
  return ans
end
