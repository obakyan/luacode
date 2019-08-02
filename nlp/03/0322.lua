r = io.open("uk.txt", "r")
for line in r:lines() do
  if line:find("Category") then
    a = line:gsub("%[%[Category:", ""):gsub("%]%]", "")
    print(a)
  end
end
r:close()
