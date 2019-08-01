r1, r2 = io.open("z_0212_1.txt", "r"), io.open("z_0212_2.txt", "r")
w = io.open("z_0213.txt", "w")
l1, l2 = r1:read(), r2:read()
while l1 do
  w:write(l1 .. "\t" .. l2 .. "\n")
  l1, l2 = r1:read(), r2:read()
end
w:close()
r1:close() r2:close()
