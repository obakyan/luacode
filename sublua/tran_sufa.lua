local mmi, mma = math.min, math.max
local mfl, mce = math.floor, math.ceil
local TranSufA = {}
TranSufA.makeSufA = function(self)
  self.sufa = {}
  local n = #self.str
  local idx, tbl1, tbl2 = self.sufa, {}, {}
  local tmp_tbl = {}
  for i = 1, n do
    idx[i] = i
    tbl1[i] = self.str:sub(i, i):byte() - 95 -- "a" = 97
    tbl2[i] = 0
    tmp_tbl[i] = 0
  end
  idx[n + 1], tbl1[n + 1], tbl2[n + 1] = n + 1, 1, 0
  n = n + 1 -- add empty to last
  table.sort(idx, function(a, b) return tbl1[a] < tbl1[b] end)
  local step, stepflag = 1, true
  while step < n do
    local v = stepflag and tbl1 or tbl2
    local vd = stepflag and tbl2 or tbl1
    stepflag = not stepflag
    local stepdst = {}
    for i = 1, n do
      local dst = i + step
      if n < dst then dst = dst - n end
      stepdst[i] = dst
    end
    local left, major = 1, v[idx[1]]
    local minor_min = v[stepdst[idx[1]]]
    local minor_max = minor_min
    local minormap = {}
    local cur = 0
    for i = 1, n do
      local minor = v[stepdst[idx[i]]]
      if minormap[minor] then minormap[minor] = minormap[minor] + 1
      else minormap[minor] = 1
      end
      minor_min, minor_max = mmi(minor_min, minor), mma(minor_max, minor)
      local isend = i == n or major ~= v[idx[i + 1]]
      if isend then
        local right = i
        if left == right then
          cur = cur + 1
          vd[idx[left]] = cur
        elseif minor_min ~= minor_max then
          local minortbl = {}
          for k, _u in pairs(minormap) do table.insert(minortbl, k) end
          table.sort(minortbl)
          local offset = 0
          for i = 1, #minortbl do
            local cnt = minormap[minortbl[i]]
            minormap[minortbl[i]] = i
            minortbl[i] = offset -- reuse
            offset = offset + cnt
          end
          for j = left, right do
            local idxj = idx[j]
            local minor_idx = minormap[v[stepdst[idxj]]]
            local ofst = minortbl[minor_idx]
            ofst = ofst + 1
            minortbl[minor_idx] = ofst
            tmp_tbl[ofst] = idxj
            vd[idxj] = cur + minor_idx
          end
          cur = cur + #minortbl
          for j = left, right do
            idx[j] = tmp_tbl[j - left + 1]
          end
        else
          cur = cur + 1
          for j = left, right do
            vd[idx[j]] = cur
          end
        end
        if i < n then
          left, major = i + 1, v[idx[i + 1]]
          minor_min = v[stepdst[idx[i + 1]]]
          minor_max = minor_min
          minormap = {}
        end
      end
    end
    step = step * 2
  end
  -- remove empty from first (O(N))
  table.remove(self.sufa, 1)
  n = n - 1
  self.sufa_inv = {}
  for i = 1, n do self.sufa_inv[i] = 0 end
  for i = 1, n do
    self.sufa_inv[self.sufa[i]] = i
  end
end
TranSufA.makeLCPA = function(self)
  assert(self.sufa)
  local n = #self.sufa
  self.lcpa = {}
  local str, sufa, lcpa = self.str, self.sufa, self.lcpa
  for i = 1, n - 1 do lcpa[i] = 0 end
  local spos = 0
  for i = 1, n do
    local lcppos = self.sufa_inv[i]
    if lcppos < n then
      local len = spos
      local p1, p2 = sufa[lcppos], sufa[lcppos + 1]
      p1, p2 = p1 + spos, p2 + spos
      while p1 <= n and p2 <= n do
        if str:sub(p1, p1) == str:sub(p2, p2) then
          len = len + 1
          p1, p2 = p1 + 1, p2 + 1
        else break
        end
      end
      lcpa[lcppos] = len
      spos = mma(0, len - 1)
    end
  end
end

TranSufA.lowerBound = function(self, s)
  if s <= self.str:sub(self.sufa[1], #self.str) then
    return 1
  end
  if self.str:sub(self.sufa[#self.str], #self.str) < s then
    return #self.str + 1
  end
  local min, max = 1, #self.str
  while 1 < max - min do
    local mid = mfl((min + max) / 2)
    if s <= self.str:sub(self.sufa[mid], #self.str) then
      max = mid
    else
      min = mid
    end
  end
  return max
end

TranSufA.create = function(self, str)
  self.str = str
  self:makeSufA()
  self:makeLCPA()
end

TranSufA.new = function(str)
  local obj = {}
  setmetatable(obj, {__index = TranSufA})
  obj:create(str)
  return obj
end

-- sample
local s = io.read()
local sa = TranSufA.new(s)
print(os.clock())
-- print(table.concat(sa.sufa, " "))
-- print(table.concat(sa.sufa_inv, " "))
-- print(table.concat(sa.lcpa, " "))
