local function a(s)
  local ret = ""
  for p, c in utf8.codes(s) do
    if 97 <= c and c <= 122 then
      c = 219 - c
    end
    ret = ret .. utf8.char(c)
  end
  return ret
end
print(a("asdfASDF"))
print(a("あasdfいasdf"))
