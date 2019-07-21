local function heldkarp_prepare(n)
  local tot = 1
  local alltask = {}
  local stagetask = {}
  for i = 1, n do
    tot = tot * 2
    alltask[i] = {}
    stagetask[i] = {}
  end
  for i = 1, n do
    for j = 1, tot - 1 do
      -- set inf value
      alltask[i][j] = 1000000007
    end
  end
  for i = 1, tot - 1 do
    local ti = i
    local cnt = 0
    for j = 1, n do
      if ti % 2 == 1 then
        cnt = cnt + 1
        ti = ti - 1
      end
      ti = ti / 2
    end
    table.insert(stagetask[cnt], i)
  end
  -- set first state
  local tmp = 1
  for i = 1, n do
    alltask[i][tmp] = 0
    tmp = tmp * 2
  end
  return tot, alltask, stagetask
end

local function heldkarp_doall(n, alltask, stagetask)
  for stage = 1, n - 1 do
    local stlen = #stagetask[stage]
    for i_stagetask = 1, stlen do
      local used = stagetask[stage][i_stagetask]
      local t_used = used
      for i = 1, n do
        if t_used % 2 == 1 then
          local val = alltask[i][used]
          local mul = 1
          local tmp = used
          for j = 1, n do
            if tmp % 2 == 0 then
              -- alltask[j][used + mul] = val + func(from i to j)
            else
              tmp = tmp - 1
            end
            tmp = tmp / 2
            mul = mul * 2
          end
          t_used = t_used - 1
        end
        t_used = t_used / 2
      end
    end
  end
end

local function heldkarp_getresult(n, tot, alltask)
  local ret = 0
  for i = 1, n do
    -- ret = mma(ret, alltask[i][tot - 1])
  end
  return ret
end
