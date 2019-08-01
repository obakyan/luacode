n = arg[1]
assert(n, "set argument N")
n = tonumber(n)
r = io.open("hightemp.txt", "r")
w = io.open("z_0215.txt", "w")
t = {}
l = r:read()
while l do
  table.insert(t, l)
  l = r:read()
end
for i = #t + 1 - n, #t do
  w:write(t[i] .. "\n")
end
w:close()
r:close()
