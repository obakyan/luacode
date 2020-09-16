package.path = package.path .. ';./../abmatch.lua'
local ABmatch = require("abmatch")
--sample
-- 49 page of https://www.slideshare.net/chokudai/abc010-35598499
local abm = ABmatch.new(4, 4)
abm:addEdge(1, 1) abm:addEdge(1, 4)
abm:addEdge(2, 1) abm:addEdge(2, 2)
abm:addEdge(3, 2) abm:addEdge(3, 4)
abm:addEdge(4, 2) abm:addEdge(4, 3)
abm:matching()
local cnt = 0
for i = 1, 4 do
  if abm.dst[i] then cnt = cnt + 1 end
end
assert(4 == cnt)
