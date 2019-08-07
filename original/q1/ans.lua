local mfl = math.floor

local function comp(a, b)
  return a < b
end

local function lower_bound(ary, x)
  local num = #ary
  if num == 0 then return 1 end
  if not comp(ary[1], x) then return 1 end
  if comp(ary[num], x) then return num + 1 end
  local min, max = 1, num
  while 1 < max - min do
    local mid = mfl((min + max) / 2)
    if comp(ary[mid], x) then
      min = mid
    else
      max = mid
    end
  end
  return max
end

local n, m = io.read("*n", "*n")
local a, b = {}, {}
local c, d = {}, {}
for i = 1, n do
  a[i], b[i] = io.read("*n", "*n")
end
for j = 1, m do
  c[j], d[j] = io.read("*n", "*n")
end
table.sort(c)
table.sort(d)
local csum, dsum = {c[1]}, {d[1]}
for i = 2, m do
  csum[i] = csum[i - 1] + c[i]
  dsum[i] = dsum[i - 1] + d[i]
end

local function solve(s, t, tsum)
  local len = 0LL
  for i = 1, n do
    local lb = lower_bound(t, s[i])
    if 1 < lb then
      len = len + s[i] * (lb - 1) - tsum[lb - 1]
      len = len + tsum[n] - tsum[lb - 1] - s[i] * (m - lb + 1)
    else
      len = len + tsum[n] - m * s[i]
    end
  end
  return len
end
local ret = solve(a, c, csum) + solve(b, d, dsum)
local str = tostring(ret):gsub("LL", "")
print(str)
