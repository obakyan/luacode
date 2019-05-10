local n, m = io.read("*n", "*n","*l")
local str = io.read()
local posval = {}
for strnum in string.gmatch(str, "%d+") do
  table.insert(posval, tonumber(strnum))
end

local parent = {}
for i = 1, n do parent[i] = 0 end
function findroot(x)
  local cand = x
  while(parent[cand] ~= 0) do
    cand = parent[cand]
  end
  return cand
end

for i = 1, m do
  local a, b = io.read("*n", "*n")
  local aroot, broot = findroot(a), findroot(b)
  if(aroot ~= broot) then
    parent[broot] = aroot
  end
end
local ret = 0
for i = 1, n do
  local gsrc, gdst = findroot(i), findroot(posval[i])
  if(gsrc ~= 0 and gsrc == gdst) then ret = ret + 1 end
end
print(ret)
