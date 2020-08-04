local mfl = math.floor


local function llprint(llnumber)
  --usage: llprint(2 * 1234567890123456LL)
  local str = tostring(llnumber):gsub("LL", "")
  print(str)
end

local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
long long atoll(const char*);
]]

local function lltonumber(str)
  return C.atoll(str)
end

local function getstr14(v)
  local z = 10000000000000 -- 10^13
  local y = 0
  while z < v do
    y = y + 1
    v = v - z
  end
  v = tostring(v)
  if y == 0 then
    return v
  elseif #v < 13 then
    return y .. string.rep("0", 13 - #v) .. v
  else
    return y .. v
  end
end
zz = 500000000000123 --5 * 10^14 + x
print(getstr14(zz))
zz = 512301230123012 --5 * 10^14 + x
print(getstr14(zz))
zz = 1
print(getstr14(zz))

-- legacy
local function lltonumber(str)
  local ret = 0LL
  local sign = str:sub(1, 1) ~= "-"
  local begin = sign and 1 or 2
  for i = begin, #str do
    ret = ret * 10LL + str:sub(i, i):byte() - 48
  end
  if not sign then ret = ret * -1LL end
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
