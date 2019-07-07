local function bdp_prepare(n, cost)
  local tot = 1
  local alltask = {}
  local stagetask = {}
  for i = 1, n do
    tot = tot * 2
    stagetask[i] = {}
  end
  for i = 1, tot - 1 do
    alltask[i] = 150000
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
    alltask[tmp] = cost[i]
    tmp = tmp * 2
  end
  return tot, alltask, stagetask
end

local function bdp_doall(n, alltask, stagetask, cost)
  for stage = 1, n - 1 do
    local stlen = #stagetask[stage]
    for i_stagetask = 1, stlen do
      local used = stagetask[stage][i_stagetask]
      local mul = 1
      local tmp = used
      for j = 1, n do
        if tmp % 2 == 0 then
          -- alltask[used + mul] = mmi(alltask[used + mul], alltask[used] + mma(0, cost[j] - tbl[used] % 1000))
        else
          tmp = tmp - 1
        end
        tmp = tmp / 2
        mul = mul * 2
      end
    end
  end
end

local function bdp_getresult(n, tot, alltask)
  local ret = 0
  for i = 1, n do
    -- ret = mma(ret, alltask[tot - 1])
  end
  return ret
end
