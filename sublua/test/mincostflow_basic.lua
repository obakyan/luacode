package.path = package.path .. ';./../mincostflow.lua'
local MinCostFlow = require("mincostflow")

-- 58 page of http://hos.ac/slides/20150319_flow.pdf
local ans = {4, 8, 16, 30, "No"}
for i = 1, 5 do
  MinCostFlow:initialize(4, 1, 2, 10000)
  MinCostFlow:addEdge(1, 3, 2, 2)
  MinCostFlow:addEdge(1, 4, 5, 2)
  MinCostFlow:addEdge(3, 4, -1, 2)
  MinCostFlow:addEdge(3, 2, 8, 1)
  MinCostFlow:addEdge(4, 2, 3, 3)
  assert(ans[i] == MinCostFlow:getMinCostFlow(i, "No"))
end
