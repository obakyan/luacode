local n, k = io.read("*n", "*n")
local a = {}
local tmap = {}
for i = 1, n do
  a[i] = io.read("*n")
  tmap[a[i]] = {}
end
local t = {}
-- if 3 <= k then
--   k = 4 - k % 2
-- end
for ik = 1, k * n do
  for i = 1, n do
    local len = #tmap[a[i]]
    if 0 < #tmap[a[i]] then
      local rmlen = #t - tmap[a[i]][len] + 1
      for j = 1, rmlen do
        local v = t[#t]
        table.remove(tmap[v])
        table.remove(t)
      end
    else
      table.insert(t, a[i])
      table.insert(tmap[a[i]], #t)
    end
  end
end
print(table.concat(t, " "))
