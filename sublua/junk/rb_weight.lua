--[[
Reference:
"Red-Black Tree by Java & Python"
http://wwwa.pikara.ne.jp/okojisan/rb-tree/index.html
]]

--[[
ADD: self.w
[Done] push, pop, rotationL,R,LR,RL
[TBD] access, check
]]

local mfl, mce = math.floor, math.ceil
local band, bor = bit.band, bit.bor

local rb_bitmask_size = 30
local rb_bitmask = {1}
for i = 2, rb_bitmask_size do
  rb_bitmask[i] = rb_bitmask[i - 1] * 2
end

local RBTree = {}
RBTree.initColor = function(self, max_node_count)
  local a = mce(max_node_count / rb_bitmask_size)
  for i = 1, a do self.colors[i] = 0 end
end
RBTree.isRed = function(self, node_idx)
  local a = mce(node_idx / rb_bitmask_size)
  local b = node_idx - (a - 1) * rb_bitmask_size
  return 0 < band(self.colors[a], rb_bitmask[b])
end
RBTree.setRed = function(self, node_idx)
  local a = mce(node_idx / rb_bitmask_size)
  local b = node_idx - (a - 1) * rb_bitmask_size
  self.colors[a] = bit.bor(self.colors[a], rb_bitmask[b])
end
RBTree.setBlack = function(self, node_idx)
  local a = mce(node_idx / rb_bitmask_size)
  local b = node_idx - (a - 1) * rb_bitmask_size
  if 0 < band(self.colors[a], rb_bitmask[b]) then
    self.colors[a] = self.colors[a] - rb_bitmask[b]
  end
end
RBTree.rotateL = function(self, idx, right_idx)
  local l, r = self.l, self.r
  local k, v, w = self.key, self.value, self.w
  r[idx], r[right_idx], l[right_idx], l[idx] = r[right_idx], l[right_idx], l[idx], right_idx
  k[idx], k[right_idx] = k[right_idx], k[idx]
  v[idx], v[right_idx] = v[right_idx], v[idx]
  if 0 < r[idx] then w[right_idx] = w[right_idx] - w[r[idx]] end
  if 0 < l[right_idx] then w[right_idx] = w[right_idx] + w[l[right_idx]] end
end
RBTree.rotateR = function(self, idx, left_idx)
  local l, r = self.l, self.r
  local k, v, w = self.key, self.value, self.w
  l[idx], l[left_idx], r[left_idx], r[idx] = l[left_idx], r[left_idx], r[idx], left_idx
  k[idx], k[left_idx] = k[left_idx], k[idx]
  v[idx], v[left_idx] = v[left_idx], v[idx]
  if 0 < l[idx] then w[left_idx] = w[left_idx] - w[l[idx]] end
  if 0 < r[left_idx] then w[left_idx] = w[left_idx] + w[r[left_idx]] end
end
RBTree.rotateLR = function(self, idx, left_idx, leftright_idx)
  local l, r = self.l, self.r
  local k, v, w = self.key, self.value, self.w
  r[left_idx], l[leftright_idx], r[leftright_idx], r[idx] = l[leftright_idx], r[leftright_idx], r[idx], leftright_idx
  k[idx], k[leftright_idx] = k[leftright_idx], k[idx]
  v[idx], v[leftright_idx] = v[leftright_idx], v[idx]
  if 0 < l[leftright_idx] then
    w[left_idx] = w[left_idx] - 1 - w[l[leftright_idx]]
  else
    w[left_idx] = w[left_idx] - 1
  end
  if 0 < r[leftright_idx] then w[leftright_idx] = w[leftright_idx] + w[r[leftright_idx]] end
  if 0 < r[left_idx] then w[leftright_idx] = w[leftright_idx] - w[r[left_idx]] end
end
RBTree.rotateRL = function(self, idx, right_idx, rightleft_idx)
  local l, r = self.l, self.r
  local k, v, w = self.key, self.value, self.w
  l[right_idx], r[rightleft_idx], l[rightleft_idx], l[idx] = r[rightleft_idx], l[rightleft_idx], l[idx], rightleft_idx
  k[idx], k[rightleft_idx] = k[rightleft_idx], k[idx]
  v[idx], v[rightleft_idx] = v[rightleft_idx], v[idx]
  if 0 < r[rightleft_idx] then
    w[right_idx] = w[right_idx] - 1 - w[r[rightleft_idx]]
  else
    w[right_idx] = w[right_idx] - 1
  end
  if 0 < l[rightleft_idx] then w[rightleft_idx] = w[rightleft_idx] + w[l[rightleft_idx]] end
  if 0 < l[right_idx] then w[rightleft_idx] = w[rightleft_idx] - w[l[right_idx]] end
end
RBTree.create = function(self, max_node_count)
  self.node_count = 0
  self.root = 0
  self.free_nodes = {}
  for i = 1, max_node_count do self.free_nodes[i] = i end
  self.l, self.r, self.key, self.value = {}, {}, {}, {}
  self.w = {}
  self.colors = {}
  self:initColor(max_node_count)
end
RBTree.push = function(self, key, value)
  assert(value ~= nil)
  local node_idxes_by_rank = {}
  local cur_idx = 0
  local cur_rank = 1
  local parent, granp = 0, 0
  local l, r, k, v = self.l, self.r, self.key, self.value
  local w = self.w
  cur_idx = self.root
  while 0 < cur_idx do
    w[cur_idx] = w[cur_idx] + 1
    node_idxes_by_rank[cur_rank] = cur_idx
    cur_rank = cur_rank + 1
    if key < k[cur_idx] then
      cur_idx = l[cur_idx]
    else
      cur_idx = r[cur_idx]
    end
  end
  self.node_count = self.node_count + 1
  cur_idx = self.free_nodes[self.node_count]
  node_idxes_by_rank[cur_rank] = cur_idx
  w[cur_idx] = 1
  if cur_rank == 1 then
    self.root = cur_idx
  else
    parent = node_idxes_by_rank[cur_rank - 1]
    if key < k[parent] then
      l[parent] = cur_idx
    else
      r[parent] = cur_idx
    end
  end
  k[cur_idx], v[cur_idx], l[cur_idx], r[cur_idx] = key, value, 0, 0
  self:setRed(cur_idx)
  while true do
    cur_idx = node_idxes_by_rank[cur_rank]
    if cur_rank == 1 then
      self:setBlack(cur_idx)
      break
    end
    parent = node_idxes_by_rank[cur_rank - 1]
    if self:isRed(parent) then
      granp = node_idxes_by_rank[cur_rank - 2]
      if l[granp] == parent then
        if l[parent] == cur_idx then
          self:rotateR(granp, parent)
        else
          self:rotateLR(granp, parent, cur_idx)
        end
      else
        if l[parent] == cur_idx then
          self:rotateRL(granp, parent, cur_idx)
        else
          self:rotateL(granp, parent)
        end
      end
      self:setRed(granp)
      self:setBlack(parent)
      self:setBlack(cur_idx)
      cur_rank = cur_rank - 2
    else
      break
    end
  end
end

RBTree.remove = function(self, key)
  local l, r, k, v = self.l, self.r, self.key, self.value
  local w = self.w
  local node_idxes_by_rank = {}
  local cur_idx = 0
  local cur_rank = 1
  local parent, left, right, granc = 0, 0, 0, 0
  local resolve_state = 0 -- 0:OK, 1:left black count is small, 2:right is
  cur_idx = self.root
  while 0 < cur_idx do
    node_idxes_by_rank[cur_rank] = cur_idx
    if k[cur_idx] == key then
      break
    end
    cur_rank = cur_rank + 1
    if key < k[cur_idx] then
      cur_idx = l[cur_idx]
    else
      cur_idx = r[cur_idx]
    end
  end
  if 0 == cur_idx then
    return -- NOT FOUND
  end
  if 0 == l[cur_idx] then
    for i = 1, cur_rank do
      local z = node_idxes_by_rank[i]
      w[z] = w[z] - 1
    end
    self.free_nodes[self.node_count] = cur_idx
    self.node_count = self.node_count - 1
    if cur_rank == 1 then
      self.root = r[cur_idx]
      if 0 < self.root then
        self:setBlack(self.root)
      end
      return
    else
      parent = node_idxes_by_rank[cur_rank - 1]
      if l[parent] == cur_idx then
        l[parent] = r[cur_idx]
        if not self:isRed(cur_idx) then
          resolve_state = 1
        end
      else
        r[parent] = r[cur_idx]
        if not self:isRed(cur_idx) then
          resolve_state = 2
        end
      end
      cur_idx = parent
      cur_rank = cur_rank - 1
    end
  else
    local swap_idx = cur_idx
    cur_idx = l[cur_idx]
    cur_rank = cur_rank + 1
    node_idxes_by_rank[cur_rank] = cur_idx
    while 0 < r[cur_idx] do
      cur_idx = r[cur_idx]
      cur_rank = cur_rank + 1
      node_idxes_by_rank[cur_rank] = cur_idx
    end
    k[swap_idx], v[swap_idx] = k[cur_idx], v[cur_idx]
    for i = 1, cur_rank do
      local z = node_idxes_by_rank[i]
      w[z] = w[z] - 1
    end
    parent = node_idxes_by_rank[cur_rank - 1]
    if parent == swap_idx then
      l[parent] = l[cur_idx]
      if not self:isRed(cur_idx) then resolve_state = 1 end
    else
      r[parent] = l[cur_idx]
      if not self:isRed(cur_idx) then resolve_state = 2 end
    end
    self.free_nodes[self.node_count] = cur_idx
    self.node_count = self.node_count - 1
    cur_idx = parent
    cur_rank = cur_rank - 1
  end
  while 0 < resolve_state do
    if resolve_state == 1 then
      right = r[cur_idx]
      if self:isRed(right) then
        self:rotateL(cur_idx, right)
        cur_idx = right
        right = r[cur_idx]
        granc = l[right]
        if 0 < granc and self:isRed(granc) then
          self:rotateRL(cur_idx, right, granc)
          self:setBlack(granc)
          break
        end
        granc = r[right]
        if 0 < granc and self:isRed(granc) then
          self:rotateL(cur_idx, right)
          self:setBlack(granc)
          break
        end
        self:setBlack(cur_idx)
        self:setRed(right)
        break
      else
        granc = l[right]
        if 0 < granc and self:isRed(granc) then
          self:rotateRL(cur_idx, right, granc)
          self:setBlack(granc)
          break
        end
        granc = r[right]
        if 0 < granc and self:isRed(granc) then
          self:rotateL(cur_idx, right)
          self:setBlack(granc)
          break
        end
        self:setRed(right)
        if self:isRed(cur_idx) then
          self:setBlack(cur_idx)
          break
        end
        if cur_rank == 1 then break end
        cur_rank = cur_rank - 1
        parent = node_idxes_by_rank[cur_rank]
        if l[parent] == cur_idx then
          resolve_state = 1
        else
          resolve_state = 2
        end
        cur_idx = parent
      end
    else
      left = l[cur_idx]
      if self:isRed(left) then
        self:rotateR(cur_idx, left)
        cur_idx = left
        left = l[cur_idx]
        granc = r[left]
        if 0 < granc and self:isRed(granc) then
          self:rotateLR(cur_idx, left, granc)
          self:setBlack(granc)
          break
        end
        granc = l[left]
        if 0 < granc and self:isRed(granc) then
          self:rotateR(cur_idx, left)
          self:setBlack(granc)
          break
        end
        self:setBlack(cur_idx)
        self:setRed(left)
        break
      else
        granc = r[left]
        if 0 < granc and self:isRed(granc) then
          self:rotateLR(cur_idx, left, granc)
          self:setBlack(granc)
          break
        end
        granc = l[left]
        if 0 < granc and self:isRed(granc) then
          self:rotateR(cur_idx, left)
          self:setBlack(granc)
          break
        end
        self:setRed(left)
        if self:isRed(cur_idx) then
          self:setBlack(cur_idx)
          break
        end
        if cur_rank == 1 then break end
        cur_rank = cur_rank - 1
        parent = node_idxes_by_rank[cur_rank]
        if l[parent] == cur_idx then
          resolve_state = 1
        else
          resolve_state = 2
        end
        cur_idx = parent
      end
    end
  end
end

RBTree.getLeft = function(self, comp_key)
  local l, r, k, v = self.l, self.r, self.key, self.value
  local ret_key, ret_value = nil, nil
  local cur_idx = self.root
  while 0 < cur_idx do
    if k[cur_idx] <= comp_key then
      ret_key, ret_value = k[cur_idx], v[cur_idx]
      cur_idx = r[cur_idx]
    else
      cur_idx = l[cur_idx]
    end
  end
  return ret_key, ret_value
end

RBTree.getRight = function(self, comp_key)
  local l, r, k, v = self.l, self.r, self.key, self.value
  local ret_key, ret_value = nil, nil
  local cur_idx = self.root
  while 0 < cur_idx do
    if k[cur_idx] < comp_key then
      cur_idx = r[cur_idx]
    else
      ret_key, ret_value = k[cur_idx], v[cur_idx]
      cur_idx = l[cur_idx]
    end
  end
  return ret_key, ret_value
end

RBTree.access = function(self, pos)
  local l, r, w = self.l, self.r, self.w
  local k, v = self.key, self.value
  if self.node_count < pos then return nil, nil end
  local cur_idx = self.root
  local ret_key, ret_value = k[cur_idx], v[cur_idx]
  while 0 < cur_idx do
    local li = l[cur_idx]
    local lw = li == 0 and 0 or w[li]
    if lw + 1 == pos then break end
    if pos <= lw then
      cur_idx = li
    elseif lw + 1 == pos then
      break
    else
      pos = pos - lw - 1
      cur_idx = r[cur_idx]
    end
    ret_key, ret_value = k[cur_idx], v[cur_idx]
  end
  return ret_key, ret_value
end

RBTree.new = function(n)
  local obj = {}
  setmetatable(obj, {__index = RBTree})
  obj:create(n)
  return obj
end

--
-- return RBTree

local rb = RBTree.new(100000)
local rep = 50
math.randomseed(999)
local rnd = math.random
for irep = 1, rep do
  local t = {}
  local n = rnd(300, 500)
  for i = 1, n do
    local v = rnd(1, 1000000007)
    rb:push(v, -v)
    t[i] = v
  end
  table.sort(t)
  for i = n, 1, -1 do
    for j = 1, i do
      local left, lvalue = rb:getLeft(t[j] - 1)
      if t[1] < t[j] then
        assert(left == t[j - 1])
        assert(left + lvalue == 0)
      else
        assert(left == nil)
      end
      local right, rvalue = rb:getRight(t[j] + 1)
      if t[j] < t[i] then
        assert(right == t[j + 1])
        assert(right + rvalue == 0)
      else
        assert(right == nil)
      end
      left, lvalue = rb:getLeft(t[j])
      assert(left == t[j])
      assert(left + lvalue == 0)
      local center, cvalue = rb:access(j)
      assert(t[j] == center)
      assert(center + cvalue == 0)
    end
    local rmpos = rnd(1, i)
    rb:remove(t[rmpos])
    table.remove(t, rmpos)
  end
end
print(os.clock())
