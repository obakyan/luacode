local fp = io.open("hightemp.txt", "r")
local wr = io.open("z_0211.txt", "w")
for c in fp:lines() do
  c = c:gsub("\t", " ")
  wr:write(c .. "\n")
end
io.close(fp)
io.close(wr)
