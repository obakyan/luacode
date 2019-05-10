local x, y, z = {}, {}, {}
for i = 1, 4 do
  x[i], y[i], z[i] = io.read("*n", "*n", "*n")
end
for i = 2, 4 do
  x[i], y[i], z[i] = x[i] - x[1], y[i] - y[1], z[i] - z[1]
end
local e1sz = math.sqrt(x[2] * x[2] + y[2] * y[2] + z[2] * z[2])
local e1 = {x[2] / e1sz, y[2] / e1sz, z[2] / e1sz}

local innerpr = e1[1] * x[3] + e1[2] * y[3] + e1[3] * z[3]
local e2 = {
  x[3] - innerpr * e1[1],
  y[3] - innerpr * e1[2],
  z[3] - innerpr * e1[3]
  }
local e2sz = math.sqrt(e2[1] * e2[1] + e2[2] * e2[2] + e2[3] * e2[3])
for i = 1, 3 do e2[i] = e2[i] / e2sz end

local e3 = {x[4], y[4], z[4]}
innerpr = e3[1] * e1[1] + e3[2] * e1[2] + e3[3] * e1[3]
for i = 1, 3 do
  e3[i] = e3[i] - e1[i] * innerpr
end
innerpr = e3[1] * e2[1] + e3[2] * e2[2] + e3[3] * e2[3]
for i = 1, 3 do
  e3[i] = e3[i] - e2[i] * innerpr
end
local e3sz = math.sqrt(e3[1] * e3[1] + e3[2] * e3[2] + e3[3] * e3[3])
for i = 1, 3 do e3[i] = e3[i] / e3sz end
innerpr = e3[1] * x[4] + e3[2] * y[4] + e3[3] * z[4]
x[4] = x[4] - innerpr * e3[1]
y[4] = y[4] - innerpr * e3[2]
z[4] = z[4] - innerpr * e3[3]

-- print("e1 " .. table.concat(e1, " "))
-- print("e2 " .. table.concat(e2, " "))
-- print("e3 " .. table.concat(e3, " "))
-- print("v  " .. x[4] .. " " .. y[4] .. " " .. z[4])
--[[
s(x2,y2,z2) + t(x3,y3,z3) = (x,y,z)
x2 x3  s = x
y2 y3  t   y
]]
local epsilon = 1.0e-5
local s, t = 0, 0
local det = x[2] * y[3] - x[3] * y[2]
if epsilon < math.abs(det) then
  s, t = (x[4] * y[3] - y[4] * x[3]) / det, (-x[4] * y[2] + y[4] * x[2]) / det
else
  det = x[2] * z[3] - x[3] * z[2]
  s, t = (x[4] * z[3] - z[4] * x[3]) / det, (-x[4] * z[2] + z[4] * x[2]) / det
end
-- print(s, t)
if(0 <= s and 0 <= t and s + t <= 1) then print("YES") else print("NO") end
