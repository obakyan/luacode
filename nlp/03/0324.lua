local r = io.open("uk.txt", "r")
for line in r:lines() do
  local m = line:match("%[%[File:(.-)|.*")
  if m then
    print(m)
  end
end
r:close()
