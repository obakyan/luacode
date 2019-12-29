local mma = math.max
-- longest common sub sequence
-- O(n1 * n2)
-- "abcd", "bede" -> 2
-- t1, t2 is array, not string
local function getLCS(t1, t2)
  local n1 = #t1
  local n2 = #t2
  local lcs = {}
  for i = 1, n1 * n2 do lcs[i] = 0 end
  for j = 1, n2 do
    for i = 1, n1 do
      local dst = (j - 1) * n1 + i
      if t1[i] == t2[j] then
        if j == 1 or i == 1 then
          lcs[dst] = 1
        else
          lcs[dst] = lcs[dst - n1 - 1] + 1
        end
      end
      if 1 < i then
        lcs[dst] = mma(lcs[dst], lcs[dst - 1])
      end
      if 1 < j then
        lcs[dst] = mma(lcs[dst], lcs[dst - n1])
      end
    end
  end
  return lcs[n1 * n2]
end
local function getLCSstr(s1, s2)
  local t1, t2 = {}, {}
  for i = 1, #s1 do t1[i] = s1:sub(i, i):byte() end
  for i = 1, #s2 do t2[i] = s2:sub(i, i):byte() end
  return getLCS(t1, t2)
end
