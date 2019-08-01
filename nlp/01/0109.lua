s = "I couldn't believe that I could actually understand what I was reading : the phenomenal power of the human mind ."
math.randomseed(os.time())
f = nil
for v in s:gmatch("%g+") do
  if f then io.write(" ") end f = true
  if #v <= 4 then
    io.write(v)
  else
    local t = {}
    for i = 2, #v - 1 do
      table.insert(t, {v:sub(i, i), math.random()})
    end
    table.sort(t, function(a, b) return a[2] < b[2] end)
    io.write(v:sub(1, 1))
    for i = 1, #t do
      io.write(t[i][1])
    end
    io.write(v:sub(#v, #v))
  end
end
io.write("\n")
