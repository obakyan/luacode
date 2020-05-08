local WhiteBlack = {}

WhiteBlack.create = function(self)
  self.edge = {}
  self.invedge = {}
  self.leftnode = {}
  self.rightmatched = {}
  self.route = {}
  self.routelen = 0
  self.asked = {}
end

WhiteBlack.addNode = function(self, node, isLeft)
  if isLeft then
    table.insert(self.leftnode, node)
    self.edge[node] = {}
  else
    self.invedge[node] = {}
  end
end

WhiteBlack.addEdge = function(self, src, dst)
  assert(self.edge[src])
  self.edge[src][dst] = 1
  self.invedge[dst][src] = 0
end

WhiteBlack.dfs = function(self)
  local src = self.route[self.routelen]
  if self.routelen % 2 == 1 then
    for dst, c in pairs(self.edge[src]) do
      if c == 1 and not self.asked[dst] then
        self.asked[dst] = true
        self.routelen = self.routelen + 1
        self.route[self.routelen] = dst
        local ret = self:dfs()
        if ret then return true end
        self.routelen = self.routelen - 1
      end
    end
  else
    if not self.rightmatched[src] then
      self.rightmatched[src] = true
      return true
    end
    for dst, c in pairs(self.invedge[src]) do
      if c == 1 and not self.asked[dst] then
        self.asked[dst] = true
        self.routelen = self.routelen + 1
        self.route[self.routelen] = dst
        local ret = self:dfs()
        if ret then return true end
        self.routelen = self.routelen - 1
      end
    end
  end
  return false
end

WhiteBlack.run = function(self, spos)
  local tasks = {spos}
  local tasked = {}
  local dstpos = 0
  tasked[spos] = true
  for k, _u in pairs(self.asked) do
    self.asked[k] = false
  end
  self.asked[spos] = true
  self.routelen = 1
  self.route[1] = spos
  local found = self:dfs()
  if found then
    for i = 1, self.routelen - 1 do
      local src, dst = self.route[i], self.route[i + 1]
      if i % 2 == 1 then
        self.edge[src][dst] = 0
        self.invedge[dst][src] = 1
      else
        self.edge[dst][src] = 1
        self.invedge[src][dst] = 0
      end
    end
    return true
  else return false end
end

WhiteBlack.getMatchCount = function(self)
  local cnt = 0
  local lnodenum = #self.leftnode
  for i = 1, lnodenum do
    local res = self:run(self.leftnode[i])
    if res then cnt = cnt + 1 end
  end
  return cnt
end

WhiteBlack.new = function()
  local obj = {}
  setmetatable(obj, {__index = WhiteBlack})
  obj:create()
  return obj
end

--
-- return WhiteBlack


--sample
-- 49 page of https://www.slideshare.net/chokudai/abc010-35598499
local wb = WhiteBlack.new()
for i = 1, 4 do wb:addNode(i, true) end
for i = 5, 8 do wb:addNode(i, false) end
wb:addEdge(1, 5) wb:addEdge(1, 8)
wb:addEdge(2, 5) wb:addEdge(2, 6)
wb:addEdge(3, 6) wb:addEdge(3, 8)
wb:addEdge(4, 6) wb:addEdge(4, 7)
print(wb:getMatchCount())
