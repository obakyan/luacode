local mfl = math.floor
local function lower_bound(ary, x)
  local num = #ary
  if num == 0 then return 1 end
  if x <= ary[1] then return 1 end
  if ary[num] < x then return num + 1 end
  local min, max = 1, num
  while 1 < max - min do
    local mid = mfl((min + max) / 2)
    if ary[mid] < x then
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
  if x < ary[1] then return 1 end
  if ary[num] <= x then return num + 1 end
  local min, max = 1, num
  while 1 < max - min do
    local mid = mfl((min + max) / 2)
    if ary[mid] <= x then
      min = mid
    else
      max = mid
    end
  end
  return max
end
