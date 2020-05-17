local RbTree = {}
RbTree.new = function()
  local obj = {}
  setmetatable(obj, {__index = RbTree})
  return obj
end
