s = "Now I need a drink, alcoholic of course, after the heavy lectures involving quantum mechanics."
local t = {}
for v in s:gmatch("%w+") do
  table.insert(t, #v)
end
print(table.concat(t, " "))
