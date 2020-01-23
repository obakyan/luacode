-- n must be small
-- about n <= 20

local function combination_get_map(n)
  local combmap = {}
  for i = 1, n do
    combmap[i] = {}
    local ret = 1
    for j = 1, i do
      ret = mfl(ret * (i + 1 - j) / j)
      combmap[i][j] = ret
    end
  end
  return combmap
end
local function combination_get_count(combmap, n, k)
  if k < 0 then return 0
  elseif n < k then return 0
  elseif k == 0 then return 1
  else return combmap[n][k]
  end
end

local function combination_get_array(combmap, n, k, idx)
  local rem = k
  local retary = {}
  for i = 1, n do
    local useCnt = combination_get_count(combmap, n - i, rem - 1)
    local unuseCnt = combination_get_count(combmap, n - i, rem)
    if idx <= useCnt then
      rem = rem - 1
      table.insert(retary, i)
    else
      idx = idx - useCnt
    end
  end
  return retary
end
