local SparseTable = {}
SparseTable.create = function(self, n, ary, func)
  self.n = n
  self.func = func
  local spt = {{}}
  for i = 1, n do
    spt[1][i] = ary[i]
  end
  do
    local len = 1
    for i = 2, 25 do
      if n < len then break end
      spt[i] = {}
      for j = 1, n do
        if j + len <= n then
          spt[i][j] = func(spt[i - 1][j], spt[i - 1][j + len])
        else
          spt[i][j] = spt[i - 1][j]
        end
      end
      len = len * 2
    end
  end
  local sptpos = {}
  local sptlen = {}
  do
    local tmp = 1
    local pos = 1
    for len = 1, n do
      if tmp * 2 < len then
        tmp = tmp * 2
        pos = pos + 1
      end
      sptpos[len] = pos
      sptlen[len] = tmp
    end
  end
  self.spt = spt
  self.sptpos = sptpos
  self.sptlen = sptlen
end

SparseTable.query = function(self, l, r)
  local len = r - l + 1
  local tbl = self.spt[self.sptpos[len]]
  return self.func(tbl[l], tbl[ r + 1 - self.sptlen[len] ])
end

SparseTable.new = function(n, ary, func)
  local obj = {}
  setmetatable(obj, {__index = SparseTable})
  obj:create(n, ary, func)
  return obj
end

--
return SparseTable

