local ior = io.input()
local h, w = ior:read("*n", "*n")

local function getindex(i_h, i_w)
  return i_w + (i_h - 1) * w
end

local function createMap()
  -- local str = ""
  local map = {}
  for i = 1, h * w do map[i] = 0 end
  for i_h = 1, h do
    -- str = ior:read()
    -- for i_w = 1, w do
    --   local idx = getindex(i_h, i_w)
    --   if(str:sub(i_w, i_w) == "#") then
    --     map[idx] = 1
    --   end
    -- end
    for i_w = 1, w do
      local idx = getindex(i_h, i_w)
      map[idx] = ior:read("*n")
    end
  end
  return map
end

local tasks = {}
local tasknum = 0
local tasklim = h * w
