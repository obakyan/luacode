local function triplediv_solve(x)
  return x
end

local function triplediv(xmin, xmax, rep, func)
  local left_v, right_v = func(xmin), func(xmax)
  for i = 1, rep do
    local xmid1, xmid2 = (xmin * 2 + xmax) / 3, (xmin + xmax * 2) / 3
    local mid_v1, mid_v2 = func(xmid1), func(xmid2)
    if left_v > mid_v1 then
      if mid_v2 > right_v then
        xmin = xmid2
        left_v = mid_v2
      elseif mid_v1 > mid_v2 then
        xmin = xmid1
        left_v = mid_v1
      else
        xmax = xmid2
        right_v = mid_v2
      end
    else
      if mid_v2 < right_v then
        xmax = xmid1
        right_v = mid_v1
      elseif mid_v1 < mid_v2 then
        xmin = xmid1
        left_v = mid_v1
      else
        xmax = xmid2
        right_v = mid_v2
      end
    end
  end
  -- return (left_v + right_v) / 2
  return (xmin + xmax) / 2
end
