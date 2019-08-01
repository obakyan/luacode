n = arg[1]
assert(n, "set argument N")
n = tonumber(n)
r = io.open("hightemp.txt", "r")
w = io.open("z_0214.txt", "w")
for i = 1, n do
  w:write(r:read().. "\n")
end
w:close()
r:close()
