local mfl = math.floor
local function grayCode(n)
  local ret = {}
  local tot = 1
  for i = 1, n do tot = tot * 2 end
  for i = 1, tot - 1 do
    local v, m, prv = 0, 1, i % 2
    i = mfl(i / 2)
    for j = 1, n - 1 do
      local cur = i % 2
      if prv + cur == 1 then v = v + m end
      prv, m, i = cur, m * 2, mfl(i / 2)
    end
    if prv == 1 then v = v + m end
    table.insert(ret, v)
  end
  return ret
end
