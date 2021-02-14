local bls, brs = bit.lshift, bit.rshift
local bxor = bit.bxor
local bor, band = bit.bor, bit.band

-- work_func(idx)
-- v = [0, 1, 2]
local function grayWalk3(size, work_func, box)
  assert(size <= 15)
  local prv = 0
  local total = 3^size - 1
  local rep = 3^(size-1)
  local bpos = {}
  for i = 1, size do
    bpos[bls(1, i - 1)] = i
  end
  local v2 = 0
  for i = 1, size do
    box[i] = 0
  end
  local function incOne()
    if box[1] == 0 then
      box[1] = 1
      v2 = v2 + 1
    elseif box[1] == 1 then
      box[1] = 2
    else
      box[1] = 0
      v2 = v2 - 1
    end
    work_func(1)
  end
  local function incX()
    local z = band(v2, -v2) * 2
    local p = bpos[z]
    if box[p] == 0 then
      box[p] = 1
      v2 = v2 + z
    elseif box[p] == 1 then
      box[p] = 2
    else
      box[p] = 0
      v2 = v2 - z
    end
    work_func(p)
  end
  -- if need first work then use below
  work_func(1)

  incOne()
  incOne()
  for i = 1, rep - 1 do
    incX()
    incOne()
    incOne()
  end
end

-- sample
local n = 3--15
local a = {}
for i = 1, n do a[i] = 0 end

local graybox = {}
local function work_func(idx)
  a[#a+1-idx] = graybox[idx]
  print(table.concat(a, ""))
end
grayWalk3(n, work_func, graybox)
