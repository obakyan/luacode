local ior = io.input()
local h, w = ior:read("*n", "*n", "*l")

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

local taskstate = {}
for i = 1, h * w do taskstate[i] = false end
local tasks = {}
local tasknum = 0
local done = 0
local tasklim = h * w

local function addtask(idx)
  if(not taskstate[idx]) then
    taskstate[idx] = true
    tasknum = tasknum + 1
    local taskidx = tasknum % tasklim
    if taskidx == 0 then taskidx = tasklim end
    tasks[taskidx] = idx
  end
end

local function walk(src, dst)
  if map[src] + 1 < map[dst] then
    map[dst] = map[src] + 1
    addtask(dst)
  end
end

addtask(start_idx)

while(done < tasknum) do
  done = done + 1
  local taskidx = done % tasklim
  if(taskidx == 0) then taskidx = tasklim end
  local idx = tasks[taskidx]
  taskstate[idx] = false

  if w < idx then walk(idx, idx - w) end
  if idx <= (h - 1) * w then walk(idx, idx + w) end
  if 1 < w then
    if idx % w ~= 0 then walk(idx, idx + 1) end
    if idx % w ~= 1 then walk(idx, idx - 1) end
  end
end


local function getlength(start_idx, dst_idx)
  local taskstate = {}
  for i = 1, n do taskstate[i] = false end
  local tasks = {}
  local tasknum = 0
  local done = 0

  local len = {}
  for i = 1, n do len[i] = inf end
  len[start_idx] = 0

  local function addtask(idx)
    if(not taskstate[idx]) then
      taskstate[idx] = true
      tasknum = tasknum + 1
      tasks[tasknum] = idx
    end
  end
  addtask(start_idx)

  while(done < tasknum) do
    done = done + 1
    local src = tasks[done]
    taskstate[src] = false
    for dst, cost in pairs(edge[src]) do
      if len[src] + cost < len[dst] then
        len[dst] = len[src] + cost
        addtask(dst)
      end
    end
  end
  return len[dst_idx]
end
