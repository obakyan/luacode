--　cat hightemp.txt | cut -f 1 | sort | uniq -c | sort -r | gsed -e 's/  */\t/g' | cut -f 3
r = io.open("z_0212_1.txt", "r")
t = {}
for line in r:lines() do
  if not t[line] then t[line] = 1 else t[line] = t[line] + 1 end
end
r:close()
s = {}
for k, v in pairs(t) do
  table.insert(s, {k, v})
end
table.sort(s, function(a, b) return a[2] > b[2] end)
for i = 1, #s do
  print(s[i][1])
end
