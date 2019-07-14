local function uf_initialize(n)
  local parent = {}
  for i = 1, n do parent[i] = i end
  return parent
end

local function uf_findroot(idx, parent)
  while parent[idx] ~= idx do
    idx = parent[idx]
  end
  return idx
end

local function kruskal(n, line)
  -- line.c, line.i1, line.i2
  table.sort(line, function(a, b) return a.c < b.c end)
  local parent = uf_initialize(n)
  local totalcost = 0
  local used = 0
  local linenum = #line
  for i = 1, linenum do
    local c, i1, i2 = line[i].c, line[i].i1, line[i].i2
    local r1, r2 = uf_findroot(i1), uf_findroot(i2)
    parent[i1], parent[i2] = r1, r2
    if r1 ~= r2 then
      parent[r2] = r1
      parent[i2] = r1
      totalcost = totalcost + c
      used = used + 1
      if used == n - 1 then break end
    end
  end
  return totalcost
end
