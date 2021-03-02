-- use a 1D Seg class ( stage[], not stage[][])
local mfl, mce = math.floor, math.ceil
local mmi, mma = math.min, math.max
local pow2 = {1}
for i = 2, 28 do pow2[i] = pow2[i - 1] * 2 end
local SegTree = {}
SegTree.updateAll = function(self)
  for i = self.stagenum - 1, 1, -1 do
    local cnt = pow2[i]
    for j = 0, cnt - 1 do
      self.stage[cnt + j] = self.func(self.stage[(cnt + j) * 2], self.stage[(cnt + j) * 2 + 1])
    end
  end
end
SegTree.create = function(self, n, func, emptyvalue)
  self.func, self.emptyvalue = func, emptyvalue
  local stagenum, mul = 1, 1
  self.stage = {}
  while mul < n do
    mul, stagenum = mul * 2, stagenum + 1
  end
  self.stagenum = stagenum
  for i = 1, mul * 2 - 1 do self.stage[i] = emptyvalue end
  for i = 1, n do self.stage[mul + i - 1] = i end
  self:updateAll()
end
SegTree.update = function(self, idx, force)
  idx = idx + pow2[self.stagenum] - 1
  for i = self.stagenum - 1, 1, -1 do
    local dst = mfl(idx / 2)
    local rem = dst * 4 + 1 - idx
    self.stage[dst] = self.func(self.stage[idx], self.stage[rem])
    if not force and self.stage[dst] ~= self.stage[idx] then break end
    idx = dst
  end
end
SegTree.new = function(n, func, emptyvalue)
  local obj = {}
  setmetatable(obj, {__index = SegTree})
  obj:create(n, func, emptyvalue)
  return obj
end



local inf = 1000000007
local len = {}
local asked = {}
for i = 1, n do
  len[i] = inf
  asked[i] = false
end
len[1] = 0
asked[n + 1] = true

local function mergefunc(x, y)
  if asked[x] then return y
  elseif asked[y] then return x
  else
    return len[x] < len[y] and x or y
  end
end

local st = SegTree.new(n, mergefunc, n + 1)

for i = 1, n do
  local src = st.stage[1]
  if asked[src] then break end
  if inf <= len[src] then break end
  asked[src] = true
  st:update(src, true)
  for dst, cost in pairs(edge[src]) do
    if len[src] + cost < len[dst] then
      len[dst] = len[src] + cost
      st:update(dst)
    end
  end
end

print(len[n])
-- test: https://yukicoder.me/problems/no/1065
