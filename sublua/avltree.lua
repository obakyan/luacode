local mma = math.max
local mfl, mce, mmi = math.floor, math.ceil, math.min

local AvlTree = {}
AvlTree.makenode = function(self, val, parent)
  local i = self.box[#self.box]
  if not i then i = #self.v + 1
  else table.remove(self.box)
  end
  self.v[i], self.p[i] = val, parent
  self.lc[i], self.rc[i], self.l[i], self.r[i] = 0, 0, 1, 1
  return i
end
AvlTree.create = function(self, lessthan, n)
  self.lessthan = lessthan
  self.root = 1
  self.box = {}
  for i = n + 1, 2, -1 do table.insert(self.box, i) end
  -- value, leftCount, rightCount, left, right, parent
  self.v, self.lc, self.rc, self.l, self.r, self.p = {}, {}, {}, {}, {}, {}
  for i = 1, n + 1 do
    self.v[i], self.p[i] = 0, 1
    self.lc[i], self.rc[i], self.l[i], self.r[i] = 0, 0, 1, 1
  end
end

AvlTree.recalcCount = function(self, i)
  if 1 < i then
    local kl, kr = self.l[i], self.r[i]
    if 1 < kl then self.lc[i] = 1 + mma(self.lc[kl], self.rc[kl])
    else self.lc[i] = 0
    end
    if 1 < kr then self.rc[i] = 1 + mma(self.lc[kr], self.rc[kr])
    else self.rc[i] = 0
    end
  end
end
AvlTree.recalcCountAll = function(self, i)
  while 1 < i do
    self:recalcCount(i)
    i = self.p[i]
  end
end

AvlTree.rotR = function(self, parent)
  local granp, child = self.p[parent], self.l[parent]
  self.r[child], self.l[parent] = parent, self.r[child]
  self.p[child], self.p[parent] = granp, child
  self.p[self.l[parent]] = parent
  if 1 < granp then
    if self.l[granp] == parent then
      self.l[granp] = child
    else
      self.r[granp] = child
    end
  else
    self.root = child
  end
end

AvlTree.rotL = function(self, parent)
  local granp, child = self.p[parent], self.r[parent]
  self.l[child], self.r[parent] = parent, self.l[child]
  self.p[child], self.p[parent] = granp, child
  self.p[self.r[parent]] = parent
  if 1 < granp then
    if self.r[granp] == parent then
      self.r[granp] = child
    else
      self.l[granp] = child
    end
  else
    self.root = child
  end
end

AvlTree.rotLR = function(self, lparent, rparent)
  local sp, sl, sr = self.p, self.l, self.r
  local granp, d = sp[rparent], sr[lparent]
  sp[lparent], sr[lparent] = d, sl[d]
  sp[rparent], sl[rparent] = d, sr[d]
  sp[sl[d]], sp[sr[d]] = lparent, rparent
  sp[d], sl[d], sr[d] = granp, lparent, rparent
  if 1 < granp then
    if sr[granp] == rparent then sr[granp] = d
    else sl[granp] = d
    end
  else self.root = d
  end
end

AvlTree.rotRL = function(self, rparent, lparent)
  local sp, sl, sr = self.p, self.l, self.r
  local granp, d = sp[lparent], sl[rparent]
  sp[rparent], sl[rparent] = d, sr[d]
  sp[lparent], sr[lparent] = d, sl[d]
  sp[sr[d]], sp[sl[d]] = rparent, lparent
  sp[d], sr[d], sl[d] = granp, rparent, lparent
  if 1 < granp then
    if sl[granp] == lparent then sl[granp] = d
    else sr[granp] = d
    end
  else self.root = d
  end
end

AvlTree.push = function(self, val)
  if self.root <= 1 then self.root = self:makenode(val, 1) return end
  local pos = self.root
  while true do
    if self.lessthan(val, self.v[pos]) then
      if 1 < self.l[pos] then
        pos = self.l[pos]
      else
        self.l[pos] = self:makenode(val, pos)
        pos = self.l[pos]
        break
      end
    else
      if 1 < self.r[pos] then
        pos = self.r[pos]
      else
        self.r[pos] = self:makenode(val, pos)
        pos = self.r[pos]
        break
      end
    end
  end
  while 1 < pos do
    local child, parent = pos, self.p[pos]
    if parent <= 1 then
      break
    end
    self:recalcCount(parent)
    local lcp_m_rcp = self.lc[parent] - self.rc[parent]
    if lcp_m_rcp % 2 ~= 0 then -- 1 or -1
      pos = parent
    elseif lcp_m_rcp == 2 then
      if self.lc[child] - 1 == self.rc[child] then
        self:rotR(parent)
        self:recalcCountAll(parent)
      else
        self:rotLR(child, parent)
        self:recalcCount(child)
        self:recalcCountAll(parent)
      end
      break
    elseif lcp_m_rcp == -2 then
      if self.rc[child] - 1 == self.lc[child] then
        self:rotL(parent)
        self:recalcCountAll(parent)
      else
        self:rotRL(child, parent)
        self:recalcCount(child)
        self:recalcCountAll(parent)
      end
      break
    else
      break
    end
  end
end

AvlTree.rmsub = function(self, node)
  while 1 < node do
    self:recalcCount(node)
    if self.lc[node] == self.rc[node] then
      node = self.p[node]
    elseif self.lc[node] + 1 == self.rc[node] then
      self:recalcCountAll(self.p[node])
      break
    else
      if self.lc[self.r[node]] == self.rc[self.r[node]] then
        self:rotL(node)
        self:recalcCountAll(node)
        break
      elseif self.lc[self.r[node]] + 1 == self.rc[self.r[node]] then
        local nr = self.r[node]
        self:rotL(node)
        self:recalcCount(node)
        node = nr
      else
        local nr = self.r[node]
        local nrl = self.l[nr]
        self:rotRL(nr, node)
        self:recalcCount(nr)
        self:recalcCount(node)
        node = nrl
      end
    end
  end
end

AvlTree.pop = function(self)
  local node = self.root
  while 1 < self.l[node] do
    node = self.l[node]
  end
  local v = self.v[node]
  local kp = self.p[node]
  self.p[self.r[node]] = kp
  if 1 < kp then
    self.l[kp] = self.r[node]
    self:rmsub(kp)
  else
    self.root = self.r[node]
  end
  table.insert(self.box, node)
  return v
end

AvlTree.new = function(lessthan, n)
  local obj = {}
  setmetatable(obj, {__index = AvlTree})
  obj:create(lessthan, n)
  return obj
end

--
return AvlTree
