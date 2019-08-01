-- mac (need gsed)
-- wc hightemp.txt | gsed -e 's/ \{1,\}/\t/g' | cut -f2 | { v=$(cat) ;echo $(($v / 4)); } | { v=$(cat) ;split -l $v hightemp.txt y_0216_;}

n = arg[1]
assert(n, "set argument N")
n = tonumber(n)
r = io.open("hightemp.txt", "r")
t = {}
l = r:read()
while l do
  table.insert(t, l)
  l = r:read()
end
r:close()

line_per_file = math.floor(#t / n)
for i = 1, n do
  local w = io.open("z_0216_" .. i .. ".txt", "w")
  for j = 1 + (i - 1) * line_per_file, math.min(#t, i * line_per_file) do
    w:write(t[j] .. "\n")
  end
  w:close()
end
