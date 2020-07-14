local bls, brs = bit.lshift, bit.rshift
local bxor = bit.bxor

local function grayCode(x)
  return bxor(x, brs(x, 1))
end
