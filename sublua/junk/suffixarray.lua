local mmi, mma = math.min, math.max
local n = io.read("*n", "*l")
local s = io.read()
local sa = {}
for i = 1, n do
  table.insert(sa, {i, s:sub(i, n)})
end
table.sort(sa, function(x, y) return x[2] < y[2] end)
local lcpa = {}
for i = 1, n do
  lcpa[i] = {}
  for j = 1, n do
    lcpa[i][j] = 0
  end
end
for i = 1, n - 1 do
  local len = mmi(#sa[i][2], #sa[i + 1][2])
  local c = 0
  for j = 1, len do
    if sa[i][2]:sub(j, j) == sa[i + 1][2]:sub(j, j) then
      c = c + 1
    else break end
  end
  local i1, i2 = sa[i][1], sa[i + 1][1]
  lcpa[i1][i2], lcpa[i2][i1] = c, c
end
for i = 1, n - 2 do
  local prv = lcpa[sa[i][1]][sa[i + 1][1]]
  if 0 < prv then
    for j = i + 1, n - 1 do
      local nxt = lcpa[sa[j][1]][sa[j + 1][1]]
      if nxt == 0 then
        break
      else
        prv = mmi(prv, nxt)
        lcpa[sa[i][1]][sa[j + 1][1]], lcpa[sa[j + 1][1]][sa[i][1]] = prv, prv
      end
    end
  end
end
