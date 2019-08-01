local fp = io.open("hightemp.txt", "r")
local cnt = 0
for c in fp:lines() do
  cnt = cnt + 1
end
io.close(fp)
print(cnt)
