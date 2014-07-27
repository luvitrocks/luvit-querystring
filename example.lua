local stringify = require('./').stringify

local s = stringify({['foo'] = 'bar'})
p(s)
