local n, m = io.read("*n", "*n")
local edge = {}
for i = 1, m do
  local a, b, c = io.read("*n", "*n", "*n")
  table.insert(edge, {a, b, c})
end
local len = {}
local inf = 10000000000
for i = 1, n do len[i] = -inf end
len[1] = 0
local lim = n + 4
for i = 1, lim do
  for j = 1, m do
    local src, dst, c = edge[j][1], edge[j][2], edge[j][3]
    if len[src] ~= -inf and len[dst] < len[src] + c then
      len[dst] = len[src] + c
      if i == lim then
        len[dst] = inf
      end
    end
  end
end
for i = 1, lim do
  for j = 1, m do
    local src, dst, c = edge[j][1], edge[j][2], edge[j][3]
    if len[src] == inf then
      len[dst] = inf
    end
  end
end
print(inf <= len[n] and "inf" or len[n])
