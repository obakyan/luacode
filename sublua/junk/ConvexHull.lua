
local n = io.read("*n")
local x, y = {}, {}
local cvidx = {}
for i = 1, n do
  x[i], y[i] = io.read("*n", "*n")
  cvidx[i] = i
end
if n == 2 then
  print(mmi(mab(x[1] - x[2]), mab(y[1] - y[2])))
end
table.sort(cvidx, function(a, b)
  if x[a] == x[b] then
    return y[a] < y[b]
  else
    return x[a] < x[b]
  end
end)
-- down
local tp1 = {cvidx[1], cvidx[2]}
for i = 3, n do
  local xidx = cvidx[i]
  while true do
    if #tp1 < 2 then break end
    local prv_vec_x = x[tp1[#tp1]] - x[tp1[#tp1 - 1]]
    local prv_vec_y = y[tp1[#tp1]] - y[tp1[#tp1 - 1]]
    local nxt_vec_x = x[xidx] - x[tp1[#tp1]]
    local nxt_vec_y = y[xidx] - y[tp1[#tp1]]
    local cp = 1LL * prv_vec_x * nxt_vec_y - 1LL * prv_vec_y * nxt_vec_x
    if cp <= 0LL then
      table.remove(tp1)
    else
      break
    end
  end
  table.insert(tp1, xidx)
end
-- up
local tp2 = {cvidx[1], cvidx[2]}
for i = 3, n do
  local xidx = cvidx[i]
  while true do
    if #tp2 < 2 then break end
    local prv_vec_x = x[tp2[#tp2]] - x[tp2[#tp2 - 1]]
    local prv_vec_y = y[tp2[#tp2]] - y[tp2[#tp2 - 1]]
    local nxt_vec_x = x[xidx] - x[tp2[#tp2]]
    local nxt_vec_y = y[xidx] - y[tp2[#tp2]]
    local cp = 1LL * prv_vec_x * nxt_vec_y - 1LL * prv_vec_y * nxt_vec_x
    if 0LL <= cp then
      table.remove(tp2)
    else
      break
    end
  end
  table.insert(tp2, xidx)
end
local cycle = tp1
for i = #tp2 - 1, 2, -1 do
  table.insert(cycle, tp2[i])
end
local cn = #cycle
