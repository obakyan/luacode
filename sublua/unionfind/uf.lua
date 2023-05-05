local UF = {}
UF.create = function(self, n)
  self.parent = {}
  for i = 1, n do
    self.parent[i] = i
  end
end
UF.getroot = function(self, idx)
  local parent = self.parent
  local idx_update = idx
  while parent[idx] ~= idx do
    idx = parent[idx]
  end
  while parent[idx_update] ~= idx do
    parent[idx_update], idx_update = idx, parent[idx_update]
  end
  return idx
end
UF.unite = function(self, a, b)
  local ra = self:getroot(a)
  local rb = self:getroot(b)
  self.parent[b], self.parent[rb] = ra, ra
end
UF.new = function(n)
  local obj = {}
  setmetatable(obj, {__index = UF})
  obj:create(n)
  return obj
end

--
return UF
