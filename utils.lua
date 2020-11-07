local utils = {};

function utils.create2Darray(rows, cols)
  local grid = {};
  for i = 1,rows do
    grid[i] = {};
    for j = 1,cols do
      grid[i][j] = 0;
    end
  end
  return grid;
end

function utils.getTableSize(tab)
  local size = 0;
  for i,v in ipairs(tab) do
    size = size + 1;
  end
  return size;
end

function utils.randomchoice(t) --Selects a random item from a table
    local keys = {}
    for key, value in pairs(t) do
        keys[#keys+1] = key --Store keys in another table
    end
    index = keys[math.random(1, #keys)]
    return t[index]
end

function utils.sleep(s) -- Stops execution for a given seconds
  local start = os.clock()
  while os.clock() - start < s do end
end



function utils.table_deep_copy(obj, seen)
  -- Handle non-tables and previously-seen tables.
	if type(obj) ~= 'table' then return obj end
	if seen and seen[obj] then return seen[obj] end

	-- New table; mark it as seen an copy recursively.
	local s = seen or {}
	local res = {}
	s[obj] = res
	for k, v in next, obj do res[utils.table_deep_copy(k, s)] = utils.table_deep_copy(v, s) end
	return setmetatable(res, getmetatable(obj))
end

return utils;
