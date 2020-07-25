local bls, brs = bit.lshift, bit.rshift
local bxor = bit.bxor

local function grayCode(x)
  return bxor(x, brs(x, 1))
end

-- add_func(idx), rm_func(idx), work_func()
local function grayWalk(size, add_func, rm_func, work_func)
  local prv = 0
  local total = bls(1, size) - 1
  local bpos = {}
  for i = 1, size do
    bpos[bls(1, i - 1)] = i
  end
  -- if need first work then use below
  -- work_func()
  for i = 1, total do
    local v = grayCode(i)
    if prv < v then
      prv, v = v, v - prv
      add_func(bpos[v])
    else
      prv, v = v, prv - v
      rm_func(bpos[v])
    end
    work_func()
  end
end

-- sample
local a = {1, 20, 300}
local v = 0
local function add_func(idx)
  v = v + a[idx]
end
local function rm_func(idx)
  v = v - a[idx]
end
local function work_func()
  print(v)
end
grayWalk(3, add_func, rm_func, work_func)
