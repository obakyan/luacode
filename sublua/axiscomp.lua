local function axiscomp(ary)
  local z = {}
  for i = 1, #ary do
    z[i] = ary[i]
  end
  table.sort(z)
  local ac, acinv = {}, {}
  local cur = 0
  for i = 1, #z do
    if not acinv[z[i]] then
      cur = cur + 1
      ac[cur] = z[i]
      acinv[z[i]] = cur
    end
  end
  return ac, acinv
end
