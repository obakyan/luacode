local band = bit.band
local FenwickTree = {}
FenwickTree.create = function(self, n)
  self.n = n
  self.v = {}
  for i = 1, n do self.v[i] = 0 end
end
FenwickTree.add = function(self, pos, val)
  while pos <= self.n do
    self.v[pos] = self.v[pos] + val
    pos = pos + band(pos, -pos)
  end
end
FenwickTree.sum = function(self, r)
  local ret = 0
  while 0 < r do
    ret = ret + self.v[r]
    r = r - band(r, -r)
  end
  return ret
end
FenwickTree.new = function(n)
  local obj = {}
  setmetatable(obj, {__index = FenwickTree})
  obj:create(n)
  return obj
end

--
return FenwickTree
