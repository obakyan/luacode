r = io.open("uk.txt", "r")
for line in r:lines() do
  if line:find("Category") then
    print(line)
  end
end
r:close()
