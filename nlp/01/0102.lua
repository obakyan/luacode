s = "パトカー"
t = "タクシー"
ret = {}
for p, c in utf8.codes(s) do
  table.insert(ret, c)
end
i = 1
for p, c in utf8.codes(t) do
  table.insert(ret, i * 2, c)
  i = i + 1
end
for i = 1, #ret do io.write(utf8.char(ret[i])) end
io.write("\n")
