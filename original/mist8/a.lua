local t = {}
t[1] = {13, 1, 11, 19, 25, 3}
t[2] = {47, 15, 21, 43, 29, 37}
t[3] = {4, 2, 16, 36, 6, 42}
t[4] = {48, 14, 44, 30, 38, 20}
t[5] = {27, 5, 31, 41, 33, 9}
t[6] = {17, 7, 39, 45, 23, 35}
t[7] = {28, 8, 12, 18, 32, 34}
t[8] = {46, 10, 22, 40, 24, 26}

local cand = {}
for i = 1, 186 do cand[i] = 0 end
for i = 1, 5 do for j = i + 1, 6 do for k = j + 1, 7 do for l = k + 1, 8 do
  local curmax = 0
  local box = {}
  for a = 1, 4 do
    box[a] = {}
    for x = 1, 186 do box[a][x] = false end
  end
  local z = {i, j, k, l}
  for x = 1, 6 do box[1][t[i][x]] = true end
  for ia = 2, 4 do
    for x = 186, 1, -1 do
      if box[ia - 1][x] then
        for y = 1, 6 do
          box[ia][x + t[z[ia]][y]] = true
        end
      end
    end
  end
  for x = 1, 186 do
    if box[4][x] then
      cand[x] = cand[x] + 1
    end
  end
end end end end
for i = 1, 186 do
  print(i .. " " ..cand[i])
end
