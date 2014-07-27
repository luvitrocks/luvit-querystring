-- querystring module inspired in luacgi code with missed ``stringify`` method
-- which should appear in luvit > 0.8.2 versions

local string = require ('string')
local table = require('table')

local querystring = {}

function querystring.urlencodecomponent (str)
	if str then
		str = string.gsub(str, '\n', '\r\n')
		str = string.gsub(str, '([^%w])', function(c)
			return string.format('%%%02X', string.byte(c))
		end)
	end

	return str
end

-- make sure value is converted to a valid string representation
-- for querystring use
function toquerystring (val, vtype)
	vtype = vtype or type(val)

	if 'table' == vtype then
		return ''
	elseif 'string' == vtype then
		return val
	end

	return tostring(val)
end

-- insert a item into a querystring result table
function insertqueryitem(ret, key, val, sep, eq)
	local vtype = nil -- string
	local skey = nil -- string (Safe key)
	local count = 0

	vtype = type(val)
	skey = querystring.urlencodecomponent(key, sep, eq)

	-- only use numeric keys for table values
	if 'table' == vtype then
		for i, v in ipairs(val) do
			if nil ~= val then
				count = count + 1
				v = querystring.urlencodecomponent(toquerystring(v), sep, eq)
				table.insert(ret, table.concat({skey, v}, eq))
			end
		end

		if 0 == count then
			table.insert(ret, table.concat({skey, ''}, eq))
		end

		count = 0
	else
		val = querystring.urlencodecomponent(toquerystring(val, vtype), sep, eq)
		table.insert(ret, table.concat({skey, val}, eq))
	end
end

-- create a querystring from the given table.
function querystring.stringify(params, order, sep, eq)
	if not params then
		return ''
	end

	order = order or nil
	sep = sep or '&'
	eq = eq or '='
	local ret = {}
	local vtype = nil -- string
	local count = 0
	local skey = nil -- string

	if order then
		local val = nil -- mixed
		for i, key in ipairs(order) do
			val = params[key]
			insertqueryitem(ret, key, val, sep, eq)
		end
	else
		for key, val in pairs(params) do
			insertqueryitem(ret, key, val, sep, eq)
		end
	end

	if 0 == #ret then
		return ''
	end

	return table.concat(ret, sep)
end

return querystring
