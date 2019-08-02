fp = io.open("hightemp.txt", "r")
local tall = {}
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
  table.insert(tall, t)
end
fp:close()
table.sort(tall, function(a, b) return tonumber(a[3]) > tonumber(b[3]) end)
w = io.open("z_0218.txt", "w")
for i = 1, #tall do
  local t = tall[i]
  for j = 1, #t do
    w:write(t[j])
    w:write(j == #t and "\n" or "\t")
  end
end
w:close()
