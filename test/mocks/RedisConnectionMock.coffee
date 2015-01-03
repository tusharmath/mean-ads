RedisConnection = require '../../backend/connections/RedisConnection'
Q = require 'q'
{annotate, Provide} = require 'di'

class RedisConnectionMock
	constructor: ->
		@conn =
			memory: {}
			set: (key, val) -> @memory[key] = val
			get: (key) -> Q @memory[key].toString()
			incrby: (key, val) ->
				@memory[key] = 0 if not @memory[key]
				@memory[key] += val
			incr: (key) -> @incrby key, 1
annotate RedisConnectionMock, new Provide RedisConnection
module.exports = RedisConnectionMock