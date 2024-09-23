local M = {}

local function all(array, condition)
    for _, value in ipairs(array) do
        if not condition(value) then return false end
    end
    return true
end


local function find(element, array, compare)
    for _, value in ipairs(array) do
        if compare(element,value) then
            return true
        end
    end
    return false
end

local function map(func, arr)
  local result = {}
  for _, v in ipairs(arr) do
    table.insert(result, func(v))
  end
  return result
end

local function options_equal(opt1, opt2)
	if opt1 == nil and opt2 == nil then
		return true
	end
	if opt1 == nil or opt2 == nil then
		return false
	end
	if #opt1 ~= #opt2 then
		return false
	end
	return all(opt1, function(element)
		return find(element, opt2, function(a, b)
			return a.label == b.label
		end)
	end)
end

M.all = all
M.find = find
M.map = map
M.options_equal = options_equal

return M


