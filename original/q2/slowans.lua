local n = io.read("*n")
local a, b = {}, {}
for i = 1, n do
  a[i], b[i] = io.read("*n", "*n")
end
local m = io.read("*n")
local c, d = {}, {}
for j = 1, m do
  c[j], d[j] = io.read("*n", "*n")
end
local t = {}
for i = 1, n do
  for j = 1, m do
    local q, w = a[i] + c[j], b[i] * d[j]
    if not t[q] then t[q] = w
    else t[q] = t[q] + w
    end
  end
end
local z = {}
for k, v in pairs(t) do
  table.insert(z, {k, v})
end
table.sort(z, function(x, y) return x[1] < y[1] end)
print(#z)
for i = 1, #z do
  print(z[i][1] .. " " .. z[i][2])
end
