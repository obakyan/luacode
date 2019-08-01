s = "パタトクカシーー"
i = 0
for p, c in utf8.codes(s) do
  i = i + 1
  if i % 2 == 1 then io.write(utf8.char(c)) end
end
io.write("\n")
