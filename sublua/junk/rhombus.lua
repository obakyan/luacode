local mab = math.abs
local h, w = io.read("*n", "*n")
local sqn = h + w - 1
local t = {}
for i = 1, sqn do
  for j = 1, sqn do
    local idx = (i - 1) * sqn + j
    if i + j <= h then
      t[idx] = false
    elseif sqn * 2 - i - j <= h - 2 then
      t[idx] = false
    elseif h <= mab(i - j) then
      t[idx] = false
    else
      t[idx] = true
    end
  end
end
for i = 1, sqn do
  for j = 1, sqn do
    local idx = (i - 1) * sqn + j
    io.write(t[idx] and "o" or ".")
  end
  io.write("\n")
end
