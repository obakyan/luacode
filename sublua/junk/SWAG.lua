local suf_spos = 0
local pre_sum, suf_sum = {}, {}
local pre_idx_len, suf_len = 0, 0

local SWAG = {}
SWAG.create = function(self, func)
  self.func = func
  self.suf_spos = 0
  self.pre_sum = {}
  self.suf_sum = {}
  self.suf_val = {}
  self.pre_idx_len = 0
  self.suf_len = 0
end
SWAG.push = function(self, v)
  local val, sum = self.suf_val, self.suf_sum
  local len = self.suf_len + 1
  self.suf_len = len
  val[len] = v
  if len == 1 then
    sum[1] = v
  else
    sum[len] = self.func(sum[len - 1], v)
  end
end
SWAG.pop = function(self)
  local presum = self.pre_sum
  local val = self.suf_val
  local suflen = self.suf_len
  if self.pre_idx_len == 0 then
    presum[1] = val[suflen]
    for i = 2, suf_len - 1 do
      presum[i] = self.func(presum[i - 1], val[suflen + 1 - i])
    end
    self.pre_idx_len = suflen - 1
    self.suf_len = 0
  else
    self.pre_idx_len = self.pre_idx_len - 1
  end
end
SWAG.query = function(self)
  if self.pre_idx_len == 0 then
    return self.suf_sum[self.suf_len]
  elseif self.suf_len == 0 then
    return self.pre_sum[self.pre_idx_len]
  else
    return self.func(self.suf_sum[self.suf_len], self.pre_sum[self.pre_idx_len])
  end
end

local ret = 0
local cur = a[1]
local right = 1
push(1)
for i = 1, n do
  if right < i then
    push(i)
    right = i
    cur = a[i]
  end
  cur = query()
  while 1LL < cur do
    right = right + 1
    push(right)
    cur = getgcd(cur, a[right])
  end
  ret = ret + n + 1 - right
  pop()
end
print(ret)
