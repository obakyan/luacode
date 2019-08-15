local mfl = math.floor

local function get_ary_from_idx(idx, n)
  idx = idx - 1
  local box = {}
  for i = 1, n do box[i] = true end
  local rettbl = {}
  for i = n, 1, -1 do
    local pos = idx % i + 1
    idx = mfl(idx / i)
    local cnt = 0
    for j = 1, n do
      if box[j] then
        cnt = cnt + 1
        if cnt == pos then
          box[j] = false
          table.insert(rettbl, j)
          break
        end
      end
    end
  end
  return rettbl
end

local function get_idx_from_ary(ary)
  local retidx = 0
  local n = #ary
  local cpy = {}
  for i = 1, n do cpy[i] = ary[i] end
  for i = 1, n - 1 do
    for j = i + 1, n do
      if cpy[i] < cpy[j] then cpy[j] = cpy[j] - 1 end
    end
  end
  for i = n, 1, -1 do
    retidx = retidx * (n + 1 - i) + cpy[i] - 1
  end
  return retidx + 1
end

-- TEST
local N = io.read("*n")
local allpat = 1
for i = 1, N do
  allpat = allpat * i
end

for i = 1, allpat do
  local a = get_ary_from_idx(i, N)
  print(i, unpack(a))
  print(get_idx_from_ary(a))
  print("---")
end
