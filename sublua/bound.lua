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

local function upper_bound(ary, x)
  local num = #ary
  if num == 0 then return 1 end
  if comp(x, ary[1]) then return 1 end
  if not comp(x, ary[num]) then return num + 1 end
  local min, max = 1, num
  while 1 < max - min do
    local mid = mfl((min + max) / 2)
    if not comp(x, ary[mid]) then
      min = mid
    else
      max = mid
    end
  end
  return max
end
