local json = require 'cjson'
local r = io.open("jawiki-country.json", "r")
local w = io.open("uk.txt", "w")
for line in r:lines() do
  local j = json.decode(line)
  if j.title == "イギリス" then
    w:write(j.text)
  end
end
w:close()
r:close()
