r = io.open("uk.txt", "r")
for line in r:lines() do
  for i = 5, 1, -1 do
    local str = "="
    for j = 1, i do str = str .. "=" end
    local tmp = str .. ".*" .. str
    if line:find(tmp) then
      local title = line:gsub(str, "")
      print(i, title)
      break
    end
  end
end
r:close()
