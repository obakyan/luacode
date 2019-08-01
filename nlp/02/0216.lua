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
w = io.open("z_0216.txt", "w")

for i = #t + 1 - n, #t do
  w:write(t[i] .. "\n")
end
w:close()
