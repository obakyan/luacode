s = "Hi He Lied Because Boron Could Not Oxidize Fluorine. New Nations Might Also Sign Peace Security Clause. Arthur King Can."
t = {1, 5, 6, 7, 8, 9, 15, 16, 19}
tv = {}
book = {}
for i = 1, #t do tv[t[i]] = true end
local i = 0
for v in s:gmatch("%w+") do
  i = i + 1
  if tv[i] then
    book[v:sub(1, 1)] = i
  else
    book[v:sub(1, 2)] = i
  end
end
for k, v in pairs(book) do
  print(k, v)
end
