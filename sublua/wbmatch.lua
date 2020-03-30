local WhiteBlack = {}

WhiteBlack.create = function(self)
  self.edge = {}
  self.invedge = {}
  self.leftnode = {}
  self.rightmatched = {}
end

WhiteBlack.addNode = function(self, node, isLeft)
  if isLeft then
    self.leftnode[node] = true
    self.edge[node] = {}
  else
    self.invedge[node] = {}
  end
end

WhiteBlack.addEdge = function(self, src, dst)
  assert(self.leftnode[src])
  self.edge[src][dst] = 1
  self.invedge[dst][src] = 0
end

WhiteBlack.run = function(self, spos)
  local tasks = {spos}
  local tasked = {}
  local dstpos = 0
  tasked[spos] = true
  local len = {}
  len[spos] = 0
  local found = false
  while 0 < #tasks do
    local src = tasks[#tasks]
    table.remove(tasks)
    tasked[src] = false
    if self.leftnode[src] then
      for dst, c in pairs(self.edge[src]) do
        if c == 1 and (not len[dst] or len[src] + 1 < len[dst]) then
          len[dst] = len[src] + 1
          if not self.rightmatched[dst] then
            self.rightmatched[dst] = true
            found = true
            dstpos = dst
            break
          elseif not tasked[dst] then
            table.insert(tasks, dst)
            tasked[dst] = true
          end
        end
      end
    else
      if self.invedge[src] then
        for dst, c in pairs(self.invedge[src]) do
          if c == 1 and (not len[dst] or len[src] + 1 < len[dst]) then
            len[dst] = len[src] + 1
            if not tasked[dst] then
              table.insert(tasks, dst)
              tasked[dst] = true
            end
          end
        end
      end
    end
    if found then break end
  end
  if found then
    local l = len[dstpos]
    for i = l, 1, -1 do
      if i % 2 == 1 then
        for src, _u in pairs(self.invedge[dstpos]) do
          if self.edge[src][dstpos] == 1 and len[src] == i - 1 then
            self.edge[src][dstpos] = 0
            self.invedge[dstpos][src] = 1
            dstpos = src
            break
          end
        end
      else
        for src, _u in pairs(self.edge[dstpos]) do
          if self.invedge[src][dstpos] == 1 and len[src] == i - 1 then
            self.invedge[src][dstpos] = 0
            self.edge[dstpos][src] = 1
            dstpos = src
            break
          end
        end
      end
    end
    return true
  else return false end
end

WhiteBlack.getMatchCount = function(self)
  local cnt = 0
  for src, _u in pairs(self.leftnode) do
    local res = self:run(src)
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
