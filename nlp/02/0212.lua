w1, w2 = io.open("z_0212_1.txt", "w"), io.open("z_0212_2.txt", "w")
fp = io.open("hightemp.txt", "r")
for line in fp:lines() do
  line = line .. "\t"
  local t = {}
  local sstr = ""
  for p, c in utf8.codes(line) do
    if c == string.byte("\t") then
      table.insert(t, sstr)
      sstr = ""
    else
      sstr = sstr .. utf8.char(c)
    end
  end
  w1:write(t[1] .. "\n") w2:write(t[2] .. "\n")
end
fp:close()
w1:close() w2:close()
