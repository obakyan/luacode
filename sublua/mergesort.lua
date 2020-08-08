local pow2 = {1}
for i = 2, 28 do pow2[i] = pow2[i - 1] * 2 end
local function mergesort(n, ary, bufary, infvalue, sortfunc)
  local rep, mul = 0, 1
  while mul < n do
    rep, mul = rep + 1, mul * 2
  end
  for i = n + 1, mul do
    ary[i] = infvalue
  end
  for irep = 1, rep do
    local src = irep % 2 == 1 and ary or bufary
    local dst = irep % 2 == 1 and bufary or ary
    local sz = pow2[irep]
    local boxcnt = pow2[rep - irep + 1]
    for i = 1, boxcnt do
      local il = 1 + sz * 2 * (i - 1)
      local ir = il + sz
      local llim = ir - 1
      local rlim = llim + sz
      local id = il
      for j = 1, sz * 2 do
        if sortfunc(src[ir], src[il]) then
          dst[id] = src[ir] ir = ir + 1
        else
          dst[id] = src[il] il = il + 1
        end
        id = id + 1
        if llim < il then
          for k = 0, sz * 2 - j - 1 do dst[id + k] = src[ir + k] end
          break
        elseif rlim < ir then
          for k = 0, sz * 2 - j - 1 do dst[id + k] = src[il + k] end
          break
        end
      end
    end
  end
  -- local sorted_tbl_is_written_in_ary1 = rep % 2 == 0
  return rep % 2 == 0
end
