local deque = {}
deque.create = function(self)
  self.pre = {}
  self.post = {}
  self.head = 1
  self.cnt = 0
  self.pre_ofst = 0
  self.post_ofst = 0
end
deque.push_back = function(self, val)
  self.cnt = self.cnt + 1
  table.insert(self.post, val)
end
deque.push_front = function(self, val)
  self.cnt = self.cnt + 1
  table.insert(self.pre, val)
end
deque.pop_front = function(self)
  if self.cnt == 0 then return nil end
  self.cnt = self.cnt - 1
  if 0 < #self.pre - self.pre_ofst then
    local v = self.pre[#self.pre]
    table.remove(self.pre)
    return v
  else
    self.post_ofst = self.post_ofst + 1
    return self.post[self.post_ofst]
  end
end
deque.pop_back = function(self)
  if self.cnt == 0 then return nil end
  self.cnt = self.cnt - 1
  if 0 < #self.post - self.post_ofst then
    local v = self.post[#self.post]
    table.remove(self.post)
    return v
  else
    self.pre_ofst = self.pre_ofst + 1
    return self.pre[self.pre_ofst]
  end
end
