local mfl, mce = math.floor, math.ceil
local mmi, mma = math.min, math.max
local bls, brs = bit.lshift, bit.rshift
local LiChaoTree = {}

LiChaoTree.create = function(self, n, x)
  self.xinv = {}
  for i = 1, n do
    self.xinv[x[i]] = i
  end
  self.x = x
  local stagenum, mul = 1, 1
  self.a, self.b = {{}}, {{}}
  while mul < n do
    mul, stagenum = mul * 2, stagenum + 1
    self.a[stagenum] = {}
    self.b[stagenum] = {}
  end
  self.stagenum = stagenum
  self.left_stage = {}
  for i = 1, n do
    local sp, sz = 1, bls(1, stagenum - 1)
    while(i - 1) % sz ~= 0 do
      sp, sz = sp + 1, brs(sz, 1)
    end
    self.left_stage[i] = sp
  end
  self.sz_stage = {}
  local tmp, sp = 1, stagenum
  for i = 1, n do
    if tmp * 2 == i then tmp, sp = tmp * 2, sp - 1 end
    self.sz_stage[i] = sp
  end
  for i = 1, stagenum do
    local cnt = bls(1, i - 1)
    for j = 1, cnt do
      self.a[i][j] = false
      self.b[i][j] = false
    end
  end
end

LiChaoTree.lessthan = function(self, x, la, lb, ra, rb)
  if not la then return false end
  if not ra then return true end
  if not x then
    if la ~= ra then
      return la < ra
    else
      return lb < rb
    end
  end
  -- do return 1LL * la * x + lb < 1LL * ra * x + rb end
  return la * x + lb < ra * x + rb
end

LiChaoTree.addLine = function(self, new_a, new_b)
  local x, a, b = self.x, self.a, self.b
  local stagenum = self.stagenum
  local idx = 1
  local xlidx = 1
  for i = 1, stagenum do
    local sz = bls(1, stagenum - i)
    local xridx = xlidx + sz - 1
    local fl = self:lessthan(x[xlidx], new_a, new_b, a[i][idx], b[i][idx])
    local fr = self:lessthan(x[xridx], new_a, new_b, a[i][idx], b[i][idx])
    if fl and fr then
      a[i][idx] = new_a
      b[i][idx] = new_b
      break
    elseif not fl and not fr then
      break
    else
      local xmidx = xlidx + brs(sz, 1)
      local fm = self:lessthan(x[xmidx], new_a, new_b, a[i][idx], b[i][idx])
      if fl then
        if fm then
          new_a, a[i][idx] = a[i][idx], new_a
          new_b, b[i][idx] = b[i][idx], new_b
          xlidx = xmidx
          idx = idx * 2
        else
          idx = idx * 2 - 1
        end
      else
        if fm then
          new_a, a[i][idx] = a[i][idx], new_a
          new_b, b[i][idx] = b[i][idx], new_b
          idx = idx * 2 - 1
        else
          xlidx = xmidx
          idx = idx * 2
        end
      end
    end
  end
end

LiChaoTree.getMinAB = function(self, x)
  local idx = self.xinv[x]
  if not idx then print("LiChaoTree:invalid x " .. x) assert(false) return end
  local canda, candb = self.a[1][1], self.b[1][1]
  for i = self.stagenum, 2, -1 do
    local za, zb = self.a[i][idx], self.b[i][idx]
    if self:lessthan(x, za, zb, canda, candb) then
      canda, candb = za, zb
    end
    idx = brs(idx + 1, 1)
  end
  return canda, candb
end
LiChaoTree.new = function(n, x)
  local obj = {}
  setmetatable(obj, {__index = LiChaoTree})
  obj:create(n, x)
  return obj
end

--
return LiChaoTree
