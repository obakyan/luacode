local tmpmat = {}
for i = 1, n do
  tmpmat[i] = {}
end
local tmpvec = {}

local function matmat()
  for i = 1, n do
    for j = 1, n do
      local v = 0
      for k = 1, n do
        v = badd(v, bmul(mat[i][k], mat[k][j]))
      end
      tmpmat[i][j] = v
    end
  end
  for i = 1, n do for j = 1, n do
    mat[i][j] = tmpmat[i][j]
  end end
end

local function vecmat()
  for i = 1, n do
    local v = 0
    for k = 1, n do
      v = badd(v, bmul(vec[k], mat[k][i]))
    end
    tmpvec[i] = v
  end
  for i = 1, n do
    vec[i] = tmpvec[i]
  end
end
local function matvec()
  for i = 1, n do
    local v = 0
    for k = 1, n do
      v = badd(v, bmul(mat[i][k], vec[k]))
    end
    tmpvec[i] = v
  end
  for i = 1, n do
    vec[i] = tmpvec[i]
  end
end


-- destructive mat[n][n]
-- use: mod, bmul, badd, modinv
local function determinant(mat)
  local det = 1
  local n = #mat
  for i = 1, n do
    if mat[i][i] == 0 then
      local swapcol = 0
      for j = i + 1, n do
        if mat[i][j] ~= 0 then
          swapcol = j break
        end
      end
      if swapcol == 0 then det = 0 break end
      for i2 = i, n do
        mat[i2][i], mat[i2][swapcol] = mat[i2][swapcol], mat[i2][i]
      end
      det = (mod - det) % mod
    end
    local mii = mat[i][i]
    det = bmul(det, mii)
    local mii_inv = modinv(mii)
    for i2 = i + 1, n do
      local v = bmul(mat[i2][i], mii_inv)
      for j = i, n do
        -- mat[i2][j] -= mat[i][j] * mat[i2][i] / mat[i][i]
        mat[i2][j] = bsub(mat[i2][j], bmul(mat[i][j], v))
      end
    end
  end
  return det
end
