s = "paraparaparadise"
t = "paragraph"

local bs, bt = {}, {}
local add, sub, mul = {}, {}, {}
local sstr = ""
for i = 1, #s - 1 do
  sstr = s:sub(i, i + 1)
  add[sstr] = true
  sub[sstr] = true
  bs[sstr] = true
end
for i = 1, #t - 1 do
  sstr = t:sub(i, i + 1)
  add[sstr] = true
  if sub[sstr] then sub[sstr] = nil else sub[sstr] = true end
  bt[sstr] = true
end
for k, v in pairs(bs) do
  if bt[k] then mul[k] = true end
end

print("---add")
for k, v in pairs(add) do print(k) end
print("---sub")
for k, v in pairs(sub) do print(k) end
print("---mul")
for k, v in pairs(mul) do print(k) end
