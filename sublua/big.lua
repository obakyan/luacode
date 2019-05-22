local mod = 1000000007
local mfl = math.floor
--[[
10^9 + 7
a + b * 10^4 + c * 10^8
0 <= a, b < 10^4
0 <= c <= 10
(a + b * 10^4 + c * 10^8)(x + y * 10^4 + z * 10^8)
= ax + (ay + bx)10^4 + (az + by + cx)10^4 * 10^4 + (bz + cy)10^12 + cz10^16
10^16 = 930000007 mod 10^9+7
]]
local function bmul(x, y)
  local x1, y1 = x % 10000, y % 10000
  local x2, y2 = mfl(x / 10000) % 10000, mfl(y / 10000) % 10000
  local x3, y3 = mfl(x / 100000000), mfl(y / 100000000)
  local ret = (x1 * y1 + (x1 * y2 + x2 * y1) * 10000) % mod
  ret = (ret + (x1 * y3 + x2 * y2 + x3 * y1) * 10000 % mod * 10000 % mod) % mod
  ret = (ret + (x2 * y3 + x3 * y2) * 10000 % mod * 10000 % mod * 10000) % mod
  ret = (ret + x3 * y3 * 930000007) % mod
  return ret
end
