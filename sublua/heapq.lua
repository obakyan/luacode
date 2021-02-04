local mfl, mce = math.floor, math.ceil
local mmi, mma = math.min, math.max
local bls, brs = bit.lshift, bit.rshift
local Heapq = {}
Heapq.create = function(self, lt)
  self.lt = lt
  self.cnt = 0
  self.t = {}
end

Heapq.push = function(self, v)
  local hqlt = self.lt
  local hqt = self.t
  local c = self.cnt + 1
  self.cnt = c
  hqt[c] = v
  while 1 < c do
    local p = brs(c, 1)
    if hqlt(hqt[c], hqt[p]) then
      hqt[c], hqt[p] = hqt[p], hqt[c]
      c = p
    else
      break
    end
  end
end

Heapq.pop = function(self)
  local hqlt = self.lt
  local hqt = self.t
  local ret = hqt[1]
  local c = self.cnt
  hqt[1] = hqt[c]
  c = c - 1
  self.cnt = c
  local p = 1
  while true do
    local d1, d2 = p * 2, p * 2 + 1
    if c < d1 then break
    elseif c < d2 then
      if hqlt(hqt[d1], hqt[p]) then
        hqt[d1], hqt[p] = hqt[p], hqt[d1]
      end
      break
    else
      if hqlt(hqt[d1], hqt[d2]) then
        if hqlt(hqt[d1], hqt[p]) then
          hqt[d1], hqt[p] = hqt[p], hqt[d1]
          p = d1
        else break
        end
      else
        if hqlt(hqt[d2], hqt[p]) then
          hqt[d2], hqt[p] = hqt[p], hqt[d2]
          p = d2
        else break
        end
      end
    end
  end
  return ret
end

Heapq.new = function(lt)
  local obj = {}
  setmetatable(obj, {__index = Heapq})
  obj:create(lt)
  return obj
end

--
return Heapq
