local function zalgo(t, n)
  local a = {}
  a[1] = n
  local pos = 2
  local len = 0
  while pos <= n do
    while pos + len <= n and t[1 + len] == t[pos + len] do
      len = len + 1
    end
    a[pos] = len
    local i = 1
    while pos + i <= n and i + a[1 + i] < len do
      a[pos + i] = a[1 + i]
      i = i + 1
    end
    pos = pos + i
    len = 0 < len - i and len - i or 0
  end
  return a
end

local function zalgo_str(s)
  local t = {}
  for i = 1, #s do
    t[i] = s:byte(i)
  end
  return zalgo(t, #s)
end
