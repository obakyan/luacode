r = io.open("z_0212_1.txt", "r")
t = {}
for line in r:lines() do
  t[line] = true
end
r:close()
for k, v in pairs(t) do print(k) end
