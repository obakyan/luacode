local mma = math.max
local AvlTree = {}
AvlTree.makenode = function(self, val, parent)
  local node = {}
  node.v, node.lc, node.rc = val, 0, 0
  node.p = parent
  -- node.l, node.r = nil, nil
  return node
end
AvlTree.create = function(self, firstval, lessthan)
  local node = self:makenode(firstval, nil)
  self.root = node
  self.lessthan = lessthan
end

AvlTree.recalcCount = function(self, node)
  if node then
    if node.l then
      node.lc = 1 + mma(node.l.lc, node.l.rc)
    else
      node.lc = 0
    end
    if node.r then
      node.rc = 1 + mma(node.r.lc, node.r.rc)
    else
      node.rc = 0
    end
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
  self:recalcCount(parent)
  self:recalcCount(child)
  self:recalcCount(granp)
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
  self:recalcCount(parent)
  self:recalcCount(child)
  self:recalcCount(granp)
end

AvlTree.add = function(self, val)
  local pos = self.root
  local added = false
  while not added do
    if self.lessthan(val, pos.v) then
      pos.lc = pos.lc + 1
      if pos.l then
        pos = pos.l
      else
        pos.l = self:makenode(val, pos)
        pos = pos.l
        added = true
      end
    else
      pos.rc = pos.rc + 1
      if pos.r then
        pos = pos.r
      else
        pos.r = self:makenode(val, pos)
        pos = pos.r
        added = true
      end
    end
  end
  local resolve_child = pos
  while resolve_child do
    local child, parent = resolve_child, resolve_child.p
    resolve_child = nil
    if not parent then
      break
    end
    if parent.l == child then
      if parent.lc - 1 == parent.rc then
        resolve_child = parent
      elseif parent.lc - 2 == parent.rc then
        if child.lc - 1 == child.rc then
          self:rotR(child, parent)
        else
          self:rotL(child.r, child)
          self:rotR(child.r, parent)
        end
      end
    else -- parent.r == child
      if parent.rc - 1 == parent.lc then
        resolve_child = parent
      elseif parent.rc - 2 == parent.lc then
        if child.rc - 1 == child.lc then
          self:rotL(child, parent)
        else
          self:rotR(child.l, child)
          self:rotL(child.l, parent)
        end
      end
    end
  end
end

AvlTree.pop = function(self)

end

AvlTree.new = function(firstval, lessthan)
    local obj = {}
    setmetatable(obj, {__index = AvlTree})
    obj:create(firstval, lessthan)
    return obj
end


-- test
local a = AvlTree.new(1, function(x, y) return x < y end)
for i = 2, 7 do a:add(i) end
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
