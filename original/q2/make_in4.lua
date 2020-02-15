print(80000)
local ofst = 999900000
local rnd = math.random
for i = 1, 20000 do
  local r = rnd(1, 5)
  for j = 1, 5 do
    if j ~= r then
      print(ofst + (i - 1) * 5 + j .. " " .. rnd(1, 50))
    end
  end
end
print(100000)
ofst = 500000000
for i = 1, 20000 do
  local r = rnd(1, 5)
  for j = 1, 5 do
    print(ofst + (i - 1) * 5 + j .. " " .. rnd(1, 50))
  end
end
