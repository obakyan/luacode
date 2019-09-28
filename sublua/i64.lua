local mfl = math.floor

local function llprint(llnumber)
  --usage: llprint(2 * 1234567890123456LL)
  local str = tostring(llnumber):gsub("LL", "")
  print(str)
end

local function lltonumber(str)
  -- plus number only
  local ret = 0LL
  for i = 1, #str do
    ret = ret * 10LL
    ret = ret + tonumber(str:sub(i, i))
  end
  return ret
end

local i64 = {v = {0, 0}, c = 10000000000}
i64.inc = function(self, x)
  assert(0 <= x, "use dec")
  self.v[2] = self.v[2] + x
  self.v[1], self.v[2] = self.v[1] + mfl(self.v[2] / self.c), self.v[2] % self.c
end
i64.dump = function(self)
  local s2 = 0 < self.v[1] and string.format("%010d", self.v[2]) or self.v[2]
  local s1 = 0 < self.v[1] and self.v[1] or ""
  return s1 .. s2
end
i64.create = function()
  local obj = {}
  setmetatable(obj, {__index = i64})
  return obj
end
