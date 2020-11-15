local Trie = {}

Trie.new = function(self, emptyvalue)
  if not emptyvalue then emptyvalue = 33 end
  self.val = {}
  self.child = {}
  self.term = {}
  self.len = {}
  self:addNode(emptyvalue, nil)
end

Trie.addNode = function(self, v, parent)
  table.insert(self.val, v)
  table.insert(self.child, {})
  table.insert(self.term, false)
  table.insert(self.len, parent and self.len[parent] + 1 or 0)
  if parent then
    table.insert(self.child[parent], #self.val)
  end
end

Trie.add = function(self, ary)
  local val, child = self.val, self.child
  local term = self.term
  local node = 1
  for i = 1, #ary do
    local v = ary[i]
    local found = false
    for j = 1, #child[node] do
      if val[child[node][j]] == v then
        found = true
        node = child[node][j]
        break
      end
    end
    if not found then
      self:addNode(v, node)
      node = #self.val
    end
  end
  term[node] = true
end

-- other functions may be found below
--[[
https://atcoder.jp/contests/joisc2010/submissions/18106251
https://atcoder.jp/contests/tenka1-2016-final/submissions/18106028
https://atcoder.jp/contests/code-festival-2016-qualb/submissions/18089800
]]
