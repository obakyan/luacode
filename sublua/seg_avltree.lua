local mma = math.max
local mfl, mce, mmi = math.floor, math.ceil, math.min
local SegForAvl = {}
SegForAvl.updateAll = function(self)
  for i = self.stagenum - 1, 1, -1 do
    for j = 1, self.cnt[i] do
      self.stage[i][j] = self.stage[i + 1][j * 2]
    end
  end
end
SegForAvl.create = function(self, n)
  local stagenum, mul = 1, 1
  self.cnt, self.stage, self.size = {1}, {{}}, {}
  while mul < n do
    mul, stagenum = mul * 2, stagenum + 1
    self.cnt[stagenum], self.stage[stagenum] = mul, {}
  end
  for i = 1, stagenum do self.size[i] = self.cnt[stagenum + 1 - i] end
  self.stagenum = stagenum
  self.stage[stagenum][1] = false
  for i = 2, mul do self.stage[stagenum][i] = i end
  self:updateAll()
end
SegForAvl.hold = function(self)
  local idx = self.stage[1][1]
  local ridx = idx
  self.stage[self.stagenum][idx] = false
  for i = self.stagenum - 1, 1, -1 do
    local dst = mce(idx / 2)
    local rem = dst * 4 - 1 - idx
    self.stage[i][dst] = self.stage[i + 1][idx] or self.stage[i + 1][rem]
    idx = dst
  end
  return ridx
end
SegForAvl.release = function(self, idx)
  self.stage[self.stagenum][idx] = idx
  for i = self.stagenum - 1, 1, -1 do
    local dst = mce(idx / 2)
    local rem = dst * 4 - 1 - idx
    self.stage[i][dst] = self.stage[i + 1][idx] or self.stage[i + 1][rem]
    idx = dst
  end
end
SegForAvl.new = function(n)
  local obj = {}
  setmetatable(obj, {__index = SegForAvl})
  obj:create(n)
  return obj
end

local SegAvlTree = {}
SegAvlTree.makenode = function(self, val, parent)
  local i = self.seg:hold()
  self.v[i], self.p[i] = val, parent
  self.lc[i], self.rc[i], self.l[i], self.r[i] = 0, 0, 1, 1
  return i
end
SegAvlTree.create = function(self, lessthan, n)
  self.lessthan = lessthan
  self.root = 1
  self.seg = SegForAvl.new(n + 1)
  -- value, leftCount, rightCount, left, right, parent
  self.v, self.lc, self.rc, self.l, self.r, self.p = {}, {}, {}, {}, {}, {}
  for i = 1, n + 1 do
    self.v[i], self.p[i] = 0, 1
    self.lc[i], self.rc[i], self.l[i], self.r[i] = 0, 0, 1, 1
  end
end

SegAvlTree.recalcCount = function(self, i)
  if 1 < i then
    if 1 < self.l[i] then self.lc[i] = 1 + mma(self.lc[self.l[i]], self.rc[self.l[i]])
    else self.lc[i] = 0
    end
    if 1 < self.r[i] then self.rc[i] = 1 + mma(self.lc[self.r[i]], self.rc[self.r[i]])
    else self.rc[i] = 0
    end
  end
end
SegAvlTree.recalcCountAll = function(self, i)
  while 1 < i do
    self:recalcCount(i)
    i = self.p[i]
  end
end

SegAvlTree.rotR = function(self, child, parent)
  local granp = self.p[parent]
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
  self:recalcCountAll(parent)
end

SegAvlTree.rotL = function(self, child, parent)
  local granp = self.p[parent]
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
  self:recalcCountAll(parent)
end

SegAvlTree.add = function(self, val)
  if self.root <= 1 then self.root = self:makenode(val, 1) return end
  local pos = self.root
  local added = false
  while not added do
    if self.lessthan(val, self.v[pos]) then
      if 1 < self.l[pos] then
        pos = self.l[pos]
      else
        self.l[pos] = self:makenode(val, pos)
        pos = self.l[pos]
        added = true
      end
    else
      if 1 < self.r[pos] then
        pos = self.r[pos]
      else
        self.r[pos] = self:makenode(val, pos)
        pos = self.r[pos]
        added = true
      end
    end
  end
  while 1 < pos do
    local child, parent = pos, self.p[pos]
    if parent <= 1 then
      break
    end
    self:recalcCount(parent)
    if self.l[parent] == child then
      if self.lc[parent] - 1 == self.rc[parent] then
        pos = parent
      elseif self.lc[parent] - 2 == self.rc[parent] then
        self:recalcCount(child)
        if self.lc[child] - 1 == self.rc[child] then
          self:rotR(child, parent)
        else
          local cr = self.r[child]
          self:rotL(cr, child)
          self:rotR(cr, parent)
        end
        pos = 1
      else
        self:recalcCountAll(child)
        pos = 1
      end
    else -- parent.r == child
      if self.rc[parent] - 1 == self.lc[parent] then
        pos = parent
      elseif self.rc[parent] - 2 == self.lc[parent] then
        self:recalcCount(child)
        if self.rc[child] - 1 == self.lc[child] then
          self:rotL(child, parent)
        else
          local cl = self.l[child]
          self:rotR(cl, child)
          self:rotL(cl, parent)
        end
        pos = 1
      else
        self:recalcCountAll(child)
        pos = 1
      end
    end
  end
end

SegAvlTree.rmsub = function(self, node)
  while 1 < node do
    self:recalcCount(node)
    if self.lc[node] == self.rc[node] then
      node = self.p[node]
    elseif self.lc[node] + 1 == self.rc[node] then
      self:recalcCountAll(self.p[node])
      node = 1
    else
      if self.lc[self.r[node]] == self.rc[self.r[node]] then
        self:rotL(self.r[node], node)
        node = 1
      elseif self.lc[self.r[node]] + 1 == self.rc[self.r[node]] then
        local nr = self.r[node]
        self:rotL(nr, node)
        node = nr
      else
        local nrl = self.l[self.r[node]]
        self:rotR(nrl, self.r[node])
        self:rotL(nrl, node)
        node = nrl
      end
    end
  end
end

SegAvlTree.pop = function(self)
  local node = self.root
  while 1 < self.l[node] do
    node = self.l[node]
  end
  local v = self.v[node]
  if 1 < self.p[node] then
    self.p[self.r[node]] = self.p[node]
    self.l[self.p[node]] = self.r[node]
    self:rmsub(self.p[node])
  else
    self.p[self.r[node]] = 1
    self.root = self.r[node]
  end
  self.seg:release(node)
  return v
end

SegAvlTree.new = function(lessthan, n)
    local obj = {}
    setmetatable(obj, {__index = SegAvlTree})
    obj:create(lessthan, n)
    return obj
end

-- test
local a = SegAvlTree.new(function(x, y) return x < y end, 32)
-- for i = 15, 1, -1 do a:add(i) end
for i = 1, 15 do a:add(i) end
local function dumptest()
  print("--- dump ---")
  local tasks = {a.root}
  local done = 0
  while done < #tasks do
    done = done + 1
    local node = tasks[done]
    if a.u[a.p[node]] then
      print(a.v[a.p[node]] .. "_" .. a.v[node])
    else
      print(a.v[node])
    end
    print("  " .. a.lc[node] .. " " .. a.rc[node])
    if a.u[a.l[node]] then table.insert(tasks, a.l[node]) end
    if a.u[a.r[node]] then table.insert(tasks, a.r[node]) end
  end
end
dumptest()
print("--- pop ---")
for i = 1, 8 do
  print(a:pop())
end
dumptest()
