local stringify = require('../init.lua').stringify

local sTests = {
	[{['foo'] = '918854443121279438895193'}] = 'foo=918854443121279438895193',
	[{['foo'] = 'bar'}] = 'foo=bar',
	[{['foo'] = {'bar', 'quux'}}] = 'foo=bar&foo=quux',
	[{['foo'] = '1', ['bar'] = '2'}] = 'foo=1&bar=2',
	[{['my weird field'] = 'q1!2"\'w$5&7/z8)?' }] = 'my%20weird%20field=q1%212%22%27w%245%267%2Fz8%29%3F',
	[{['foo=baz'] = 'bar'}] = 'foo%3Dbaz=bar',
	[{['foo'] = 'baz=bar'}] = 'foo=baz%3Dbar',
	-- this case should be checked once more
	-- https://github.com/luvit/luvit/pull/264
	-- [{['str'] = 'foo',
	--   ['arr'] = {'1', '2', '3'},
	--   ['somenull'] = '',
	--   ['undef'] = ''}] = 'somenull=&arr=1&arr=2&arr=3&undef=&str=foo',
	[{[' foo '] = ' bar '}] = '%20foo%20=%20bar%20',
	[{['foo'] = '%zx'}] = 'foo=%25zx'
}

for input, output in pairs(sTests) do
	local str = stringify(input)

	if output ~= str then
		p('Expected', output)
		p('But got', str)
		error('Test failed ' .. input)
	end
end

-- test ordering
local soTest = {
	str = 'foo',
	arr = {1, 2, 3},
	somenull = '',
	undef = ''
}
local soOrder = {
	[{'str', 'arr', 'somenull', 'undef'}] = 'str=foo&arr=1&arr=2&arr=3&somenull=&undef='
}

for input, output in pairs(soOrder) do
	local str = stringify(soTest, input, nil, nil)

	if output ~= str then
		p('Expected', output)
		p('But got', str)
		error('Test failed ' .. input)
	end
end
