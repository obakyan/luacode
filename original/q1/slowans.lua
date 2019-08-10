local n, m = io.read("*n", "*n")
local a, b = {}, {}
local c, d = {}, {}
for i = 1, n do
  a[i], b[i] = io.read("*n", "*n")
end
for j = 1, m do
  c[j], d[j] = io.read("*n", "*n")
end
local abs = math.abs
local ret = 0LL
for i = 1, n do
  for j = 1, m do
    ret = ret + abs(a[i] - c[j]) + abs(b[i] - d[j])
  end
end
local str = tostring(ret):gsub("LL", "")
print(str)
