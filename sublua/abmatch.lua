-- Hopcroft-Karp
ABmatch = {}
ABmatch.create = function(self, an, bn)
  self.dst = {}
  self.edge = {}
  for i = 1, an do
    self.dst[i] = false
    self.edge[i] = {}
  end
  self.src = {}
  self.invcnt = {}
  self.invs = {}
  self.invpos = {}
  self.padded = {}
  for i = 1, bn do
    self.src[i] = false
    self.invs[i] = {}
  end
  self.p = {}
  self.tasks = {}
  self.level = {}
end

ABmatch.addEdge = function(self, a, b)
  table.insert(self.edge[a], b)
  if not self.dst[a] and not self.src[b] then
    self.dst[a] = b
    self.src[b] = a
  end
end

ABmatch.makeAugPath = function(self)
  local tasknum = 0
  local tasks = self.tasks
  local level = self.level
  local edge = self.edge
  local src = self.src
  local an = #self.dst
  local bn = #src
  local invcnt, invs = self.invcnt, self.invs
  local p, psize = self.p, 0
  local padded = self.padded
  local lvinf = an + 1
  for i = 1, an do
    if self.dst[i] then
      level[i] = lvinf
    else
      tasknum = tasknum + 1
      tasks[tasknum] = i
      level[i] = 1
    end
  end
  for i = 1, bn do
    invcnt[i] = 0
    padded[i] = false
  end
  local done = 0
  local lvmax = lvinf
  while done < tasknum do
    done = done + 1
    local a = tasks[done]
    if lvmax < level[a] then break end
    for i = 1, #edge[a] do
      local b = edge[a][i]
      local sb = src[b]
      if sb then
        if level[sb] == lvinf then
          tasknum = tasknum + 1
          tasks[tasknum] = sb
          level[sb] = level[a] + 1
          invcnt[b] = invcnt[b] + 1
          invs[b][invcnt[b]] = a
        elseif level[sb] == level[a] + 1 then
          invcnt[b] = invcnt[b] + 1
          invs[b][invcnt[b]] = a
        end
      else
        if lvmax == lvinf then
          lvmax = level[a]
        end
        if padded[b] then
        else
          padded[b] = true
          psize = psize + 1
          p[psize] = b
        end
        invcnt[b] = invcnt[b] + 1
        invs[b][invcnt[b]] = a
      end
    end
  end
  self.psize = psize
  return lvmax
end

-- ABmatch.dfs = function(self, b, lv)
--   for i = 1, self.invcnt[b] do
--     local a = self.invs[b][i]
--     if self.level[a] == 1 or (self.level[a] == lv and self:dfs(self.dst[a], lv - 1)) then
--       self.dst[a], self.src[b] = b, a
--       self.level[a] = -1
--       return true
--     end
--   end
-- end

ABmatch.restore = function(self, bend, lvend)
  local invs, invcnt, invpos = self.invs, self.invcnt, self.invpos
  local dst, src, level = self.dst, self.src, self.level
  local bn = #src
  for i = 1, bn do
    invpos[i] = 0
  end
  local accept = false
  local tasks = self.tasks
  local taskpos = 1
  tasks[1] = bend
  while 0 < taskpos do
    local b = tasks[taskpos]
    if accept then
      local a = invs[b][invpos[b]]
      dst[a], src[b] = b, a
      level[a] = -1
      taskpos = taskpos - 1
    else
      if invpos[b] == invcnt[b] then
        taskpos = taskpos - 1
      else
        local ip = invpos[b] + 1
        invpos[b] = ip
        local a = invs[b][ip]
        if level[a] == 1 then
          accept = true
          dst[a], src[b] = b, a
          level[a] = -1
          taskpos = taskpos - 1
        elseif level[a] + taskpos == lvend + 1 then
          taskpos = taskpos + 1
          tasks[taskpos] = dst[a]
        end
      end
    end
  end
end

ABmatch.matching = function(self)
  local an = #self.dst
  local lv = self:makeAugPath()
  while lv <= an do
    for i = 1, self.psize do
      self:restore(self.p[i], lv)
      -- self:dfs(self.p[i], lv)
    end
    lv = self:makeAugPath()
  end
end

ABmatch.new = function(an, bn)
  local obj = {}
  setmetatable(obj, {__index = ABmatch})
  obj:create(an, bn)
  return obj
end

--
return ABmatch
