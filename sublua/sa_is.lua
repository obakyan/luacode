local function SA_IS(data, data_size, word_size)
  local suffix_array = {}
  local type_tag = {} -- -2: L, -1: S, 1~: i-th LMS
  for i = 1, data_size do
    suffix_array[i] = -1
    type_tag[i] = -2
  end
  local word_count = {}
  local word_count_sum = {}
  local word_pushback_count = {}
  local word_pushfront_count = {}
  for i = 1, word_size do
    word_count[i] = 0
    word_count_sum[i] = 0
    word_pushback_count[i] = 0
    word_pushfront_count[i] = 0
  end
  local lms_count = 0
  local lms_data_indexes = {}
  local sorted_lms_data_indexes = {}
  local lms_compressed_data = {}

  for i = 1, data_size do
    word_count[data[i]] = word_count[data[i]] + 1
  end
  word_count_sum[1] = word_count[1]
  for i = 2, word_size do
    word_count_sum[i] = word_count_sum[i - 1] + word_count[i]
  end
  local prev_type = -2
  for i = data_size - 1, 1, -1 do
    if data[i] == data[i + 1] then
      type_tag[i] = prev_type
    else
      type_tag[i] = data[i] < data[i + 1] and -1 or -2
      prev_type = type_tag[i]
    end
  end
  for i = 2, data_size do
    if type_tag[i - 1] == -2 and type_tag[i] == -1 then
      lms_count = lms_count + 1
      type_tag[i] = lms_count
      lms_data_indexes[lms_count] = i
      sorted_lms_data_indexes[lms_count] = -1
      lms_compressed_data[lms_count] = -1
    end
  end
  -- put LMS
  for i = 1, lms_count do
    local idx = lms_data_indexes[i]
    local w = data[idx]
    suffix_array[word_count_sum[w] - word_pushback_count[w]] = idx
    word_pushback_count[w] = word_pushback_count[w] + 1
  end
  -- put L
  do
    local w = data[data_size]
    local offset = w == 1 and 0 or word_count_sum[w - 1]
    suffix_array[offset + 1] = data_size
    word_pushfront_count[w] = word_pushfront_count[w] + 1
  end
  for sufa_idx = 1, data_size - 1 do
    local data_idx = suffix_array[sufa_idx]
    if 1 < data_idx then
      data_idx = data_idx - 1
      if type_tag[data_idx] == -2 then
        local w = data[data_idx]
        local offset = w == 1 and 0 or word_count_sum[w - 1]
        word_pushfront_count[w] = word_pushfront_count[w] + 1
        suffix_array[offset + word_pushfront_count[w]] = data_idx
      end
    end
  end
  -- remove LMS
  for w = 1, word_size do
    word_pushback_count[w] = 0
  end
  -- put S
  for sufa_idx = data_size, 1, -1 do
    local data_idx = suffix_array[sufa_idx]
    if 1 < data_idx then
      data_idx = data_idx - 1
      if -1 <= type_tag[data_idx] then
        local w = data[data_idx]
        suffix_array[word_count_sum[w] - word_pushback_count[w]] = data_idx
        word_pushback_count[w] = word_pushback_count[w] + 1
      end
    end
  end
  local lms_data_value = 0
  local prev_lms_index = 0
  local prev_lms_data_index = 0
  for sufa_idx = 1, data_size do
    local data_idx = suffix_array[sufa_idx]
    local lms_idx = type_tag[data_idx]
    if 1 <= lms_idx then
      local is_same = false
      if 0 < prev_lms_data_index and prev_lms_index ~= lms_count and lms_idx ~= lms_count then
        local len1 = lms_data_indexes[lms_idx + 1] - data_idx
        local len2 = lms_data_indexes[prev_lms_index + 1] - prev_lms_data_index
        if len1 == len2 then
          is_same = true
          for i = 0, len1 do
            if data[i + data_idx] ~= data[i + prev_lms_data_index] then
              is_same = false
              break
            end
          end
        end
      end
      if not is_same then
        lms_data_value = lms_data_value + 1
      end
      lms_compressed_data[lms_idx] = lms_data_value
      prev_lms_index = lms_idx
      prev_lms_data_index = data_idx
    end
  end
  if lms_data_value == lms_count then
    for i = 1, lms_count do
      sorted_lms_data_indexes[lms_compressed_data[i]] = lms_data_indexes[i]
    end
  else
    local lms_sa = SA_IS(lms_compressed_data, lms_count, lms_data_value)
    for i = 1, lms_count do
      sorted_lms_data_indexes[i] = lms_data_indexes[lms_sa[i]]
    end
  end
  for i = 1, lms_count do
    local inv = lms_count + 1 - i
    if inv <= i then break end
    sorted_lms_data_indexes[i], sorted_lms_data_indexes[inv]
      = sorted_lms_data_indexes[inv], sorted_lms_data_indexes[i]
  end
  -- Second Induced Sort
  for i = 1, data_size do
    suffix_array[i] = -1
  end
  for i = 1, word_size do
    word_pushback_count[i] = 0
    word_pushfront_count[i] = 0
  end
  -- put LMS
  for i = 1, lms_count do
    local idx = sorted_lms_data_indexes[i]
    local w = data[idx]
    suffix_array[word_count_sum[w] - word_pushback_count[w]] = idx
    word_pushback_count[w] = word_pushback_count[w] + 1
  end
  -- put L
  do
    local w = data[data_size]
    local offset = w == 1 and 0 or word_count_sum[w - 1]
    suffix_array[offset + 1] = data_size
    word_pushfront_count[w] = word_pushfront_count[w] + 1
  end
  for sufa_idx = 1, data_size - 1 do
    local data_idx = suffix_array[sufa_idx]
    if 1 < data_idx then
      data_idx = data_idx - 1
      if type_tag[data_idx] == -2 then
        local w = data[data_idx]
        local offset = w == 1 and 0 or word_count_sum[w - 1]
        word_pushfront_count[w] = word_pushfront_count[w] + 1
        suffix_array[offset + word_pushfront_count[w]] = data_idx
      end
    end
  end
  -- remove LMS
  for w = 1, word_size do
    word_pushback_count[w] = 0
  end
  -- put S
  for sufa_idx = data_size, 1, -1 do
    local data_idx = suffix_array[sufa_idx]
    if 1 < data_idx then
      data_idx = data_idx - 1
      if -1 <= type_tag[data_idx] then
        local w = data[data_idx]
        suffix_array[word_count_sum[w] - word_pushback_count[w]] = data_idx
        word_pushback_count[w] = word_pushback_count[w] + 1
      end
    end
  end
  return suffix_array
end

local SAIS = {}
SAIS.create = function(self, data, data_size, word_size)
  local sufa = SA_IS(data, data_size, word_size)
  local sufa_inv = {}
  for i = 1, data_size do sufa_inv[i] = 0 end
  for i = 1, data_size do
    sufa_inv[sufa[i]] = i
  end
  self.sufa = sufa
  self.sufa_inv = sufa_inv
  -- LCPA
  local n = data_size
  local lcpa = {}
  for i = 1, n - 1 do lcpa[i] = 0 end
  local spos = 0
  for i = 1, n do
    local lcppos = sufa_inv[i]
    if lcppos < n then
      local len = spos
      local p1, p2 = sufa[lcppos], sufa[lcppos + 1]
      p1, p2 = p1 + spos, p2 + spos
      while p1 <= n and p2 <= n do
        if data[p1] == data[p2] then
          len = len + 1
          p1, p2 = p1 + 1, p2 + 1
        else break
        end
      end
      lcpa[lcppos] = len
      spos = 1 < len and len - 1 or 0
    end
  end
  self.lcpa = lcpa
end

--
return SAIS
