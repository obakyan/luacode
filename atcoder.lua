local ior = io.input()
local n, m = ior:read("*n", "*n")
local hasinfo = {}
local pos = {}
local parent = {}
local grouplen = {}
local groupidxes = {}
for i = 1, n do parent[i], grouplen[i], groupidxes[i] = i, 1, {i} end
for i = 1, n do hasinfo[i], pos[i] = false, 0 end
local isok = true

function getroot(idx)
  while(parent[idx] ~= idx) do
    idx = parent[idx]
  end
  return idx
end

for i = 1, m do
  local l, r, d = ior:read("*n", "*n", "*n")
  if(isok) then
    local lr, rr = getroot(l), getroot(r)
    if(hasinfo[l] and hasinfo[r]) then
      if(lr ~= rr) then
        local diff = pos[r] - (pos[l] + d)
        if(grouplen[lr] < grouplen[rr]) then
          for j = 1, #groupidxes[lr] do
            local tmpidx = groupidxes[lr][j]
            table.insert(groupidxes[rr], tmpidx)
            pos[tmpidx] = pos[tmpidx] + diff
          end
          grouplen[rr] = grouplen[rr] + grouplen[lr]
          grouplen[lr] = 0
          parent[l], parent[r], parent[lr] = rr, rr, rr
        else
          for j = 1, #groupidxes[rr] do
            local tmpidx = groupidxes[rr][j]
            table.insert(groupidxes[lr], tmpidx)
            pos[tmpidx] = pos[tmpidx] - diff
          end
          grouplen[lr] = grouplen[rr] + grouplen[lr]
          grouplen[rr] = 0
          parent[l], parent[r], parent[rr] = lr, lr, lr
        end
      else
        parent[l], parent[r], parent[lr] = rr, rr, rr
        isok = (d == pos[r] - pos[l])
      end
    elseif(hasinfo[r]) then
      parent[l], parent[r], parent[lr] = rr, rr, rr
      grouplen[l] = 0
      grouplen[rr] = grouplen[rr] + 1
      table.insert(groupidxes[rr], l)
      hasinfo[l] = true
      pos[l] = pos[r] - d
    elseif(hasinfo[l]) then
      parent[l], parent[r], parent[rr] = lr, lr, lr
      grouplen[lr] = grouplen[lr] + 1
      grouplen[r] = 0
      table.insert(groupidxes[lr], r)
      hasinfo[r] = true
      pos[r] = pos[l] + d
    else
      parent[l], parent[r], parent[rr] = lr, lr, lr
      grouplen[l] = 2
      grouplen[r] = 0
      table.insert(groupidxes[l], r)
      hasinfo[l], hasinfo[r] = true, true
      pos[l] = 0
      pos[r] = d
    end
  end
end
print(isok and "Yes" or "No")
