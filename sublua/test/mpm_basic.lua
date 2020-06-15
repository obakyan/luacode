package.path = package.path .. ';./../mpm.lua'
local MPM = require("mpm")

MPM:initialize(7, 1, 7)
MPM:addEdge(1, 2, 1)
MPM:addEdge(1, 3, 2)
MPM:addEdge(2, 4, 1)
MPM:addEdge(3, 5, 3)
MPM:addEdge(3, 6, 3)
MPM:addEdge(4, 5, 1)
MPM:addEdge(5, 7, 1)
MPM:addEdge(6, 7, 2)
assert(3 == MPM:getMaxFlow())
