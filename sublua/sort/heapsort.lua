local function heapsort(ary, lt)
  local n = #ary
  for i = 1, n do
    local c = i
    while 1 < c do
      local p = brs(c, 1)
      if lt(ary[c], ary[p]) then
        ary[c], ary[p] = ary[p], ary[c]
        c = p
      else
        break
      end
    end
  end
  for i = 1, n do
    local c = n + 1 - i
    ary[1], ary[c] = ary[c], ary[1]
    c = c - 1
    local p = 1
    while true do
      local d1, d2 = p * 2, p * 2 + 1
      if c < d1 then break
      elseif c < d2 then
        if lt(ary[d1], ary[p]) then
          ary[d1], ary[p] = ary[p], ary[d1]
        end
        break
      else
        if lt(ary[d1], ary[d2]) then
          if lt(ary[d1], ary[p]) then
            ary[d1], ary[p] = ary[p], ary[d1]
            p = d1
          else break
          end
        else
          if lt(ary[d2], ary[p]) then
            ary[d2], ary[p] = ary[p], ary[d2]
            p = d2
          else break
          end
        end
      end
    end
  end
end