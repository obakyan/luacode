local mma = math.max
local AvlTree = {}
AvlTree.makenode = function(self, val, parent)
  local node = {}
  node.v, node.lc, node.rc = val, 0, 0
  node.p = parent
  -- node.l, node.r = nil, nil
  return node
end
AvlTree.create = function(self, lessthan)
  self.lessthan = lessthan
end

AvlTree.recalcCount = function(self, node)
  if node then
    if node.l then node.lc = 1 + mma(node.l.lc, node.l.rc)
    else node.lc = 0
    end
    if node.r then node.rc = 1 + mma(node.r.lc, node.r.rc)
    else node.rc = 0
    end
  end
end
AvlTree.recalcCountAll = function(self, node)
  while node do
    self:recalcCount(node)
    node = node.p
  end
end

AvlTree.rotR = function(self, child, parent)
  local granp = parent.p
  child.r, parent.l = parent, child.r
  child.p, parent.p = granp, child
  if parent.l then parent.l.p = parent end
  if granp then
    if granp.l == parent then
      granp.l = child
    else
      granp.r = child
    end
  else -- granp == nil
    self.root = child
  end
  self:recalcCountAll(parent)
end

AvlTree.rotL = function(self, child, parent)
  local granp = parent.p
  child.l, parent.r = parent, child.l
  child.p, parent.p = granp, child
  if parent.r then parent.r.p = parent end
  if granp then
    if granp.r == parent then
      granp.r = child
    else
      granp.l = child
    end
  else -- granp == nil
    self.root = child
  end
  self:recalcCountAll(parent)
end

AvlTree.add = function(self, val)
  if not self.root then self.root = self:makenode(val) return end
  local pos = self.root
  local added = false
  while not added do
    if self.lessthan(val, pos.v) then
      if pos.l then
        pos = pos.l
      else
        pos.l = self:makenode(val, pos)
        pos = pos.l
        added = true
      end
    else
      if pos.r then
        pos = pos.r
      else
        pos.r = self:makenode(val, pos)
        pos = pos.r
        added = true
      end
    end
  end
  while pos do
    local child, parent = pos, pos.p
    if not parent then
      break
    end
    self:recalcCount(parent)
    if parent.l == child then
      if parent.lc - 1 == parent.rc then
        pos = parent
      elseif parent.lc - 2 == parent.rc then
        self:recalcCount(child)
        if child.lc - 1 == child.rc then
          self:rotR(child, parent)
        else
          local cr = child.r
          self:rotL(cr, child)
          self:rotR(cr, parent)
        end
        self:recalcCountAll(child)
        pos = nil
      else
        self:recalcCountAll(child)
        pos = nil
      end
    else -- parent.r == child
      if parent.rc - 1 == parent.lc then
        pos = parent
      elseif parent.rc - 2 == parent.lc then
        self:recalcCount(child)
        if child.rc - 1 == child.lc then
          self:rotL(child, parent)
        else
          local cl = child.l
          self:rotR(cl, child)
          self:rotL(cl, parent)
        end
        self:recalcCountAll(child)
        pos = nil
      else
        self:recalcCountAll(child)
        pos = nil
      end
    end
  end
end

AvlTree.rmsub = function(self, node)
  while node do
    self:recalcCount(node)
    if node.lc == node.rc then
      node = node.p
    elseif node.lc + 1 == node.rc then
      self:recalcCountAll(node.p)
      node = nil
    else
      if node.r.lc == node.r.rc then
        self:rotL(node.r, node)
        self:recalcCountAll(node)
        node = nil
      elseif node.r.lc + 1 == node.r.rc then
        local nr = node.r
        self:rotL(nr, node)
        node = nr
      else
        local nrl = node.r.l
        self:rotR(nrl, node.r)
        self:rotL(nrl, node)
        node = nrl
      end
    end
  end
end

AvlTree.pop = function(self)
  local edge = self.root
  while edge.l do
    edge = edge.l
  end
  local v = edge.v
  if edge.p then
    if edge.r then edge.r.p = edge.p end
    edge.p.l = edge.r
    self:rmsub(edge.p)
  else
    if edge.r then edge.r.p = nil end
    self.root = edge.r
  end
  return v
end

AvlTree.new = function(lessthan)
    local obj = {}
    setmetatable(obj, {__index = AvlTree})
    obj:create(lessthan)
    return obj
end


-- test
local a = AvlTree.new(function(x, y) return x < y end)
for i = 15, 1, -1 do a:add(i) end
local function dumptest()
  print("--- dump ---")
  local tasks = {a.root}
  local done = 0
  while done < #tasks do
    done = done + 1
    local node = tasks[done]
    if node.p then
      print(node.p.v .. "_" .. node.v)
    else
      print(node.v)
    end
    print("  " .. node.lc .. " " .. node.rc)
    if node.l then table.insert(tasks, node.l) end
    if node.r then table.insert(tasks, node.r) end
  end
end
dumptest()
print("--- pop ---")
for i = 1, 8 do
  print(a:pop())
end
dumptest()
