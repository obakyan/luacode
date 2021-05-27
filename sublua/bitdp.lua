local bls, brs = bit.lshift, bit.rshift

local function bdp_prepare(n, cost)
  local tot = bls(1, n)
  local alltask = {}
  local stagetask = {}
  for i = 1, n do
    stagetask[i] = {}
  end
  for i = 1, tot - 1 do
    -- set empty state
    alltask[i] = 150000
  end
  for i = 1, tot - 1 do
    local ti = i
    local cnt = 0
    for j = 1, n do
      if ti % 2 == 1 then
        cnt = cnt + 1
      end
      ti = brs(ti, 1)
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
          -- alltask[used + mul] = alltask[used] + func(to j)
        end
        tmp = brs(tmp, 1)
        mul = mul * 2
      end
    end
  end
end

local function bdp_getresult(tot, alltask)
  return alltask[tot - 1]
end
