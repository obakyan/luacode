local s, t = "paraparaparadise", "paragraph"
local bi_s, bi_t = {}, {}
local mul, add, sub = {}, {}, {}

for i = 1, #s - 1 do
  local sstr = s:sub(i, i + 1)
  add[sstr] = true
  sub[sstr] = true
  bi_s[sstr] = true
end
for i = 1, #t - 1 do
  local sstr = t:sub(i, i + 1)
  add[sstr] = true
  if sub[sstr] then
    sub[sstr] = nil
  else
    sub[sstr] = true
  end
  bi_t[sstr] = true
end
for k, v in pairs(bi_s) do
  if bi_t[k] then mul[k] = true end
end

print("---add")
for k, v in pairs(add) do print(k) end
print("---sub")
for k, v in pairs(sub) do print(k) end
print("---mul")
for k, v in pairs(mul) do print(k) end
