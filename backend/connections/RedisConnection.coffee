config = require '../config/config'
RedisProvider = require '../providers/RedisProvider'
{Inject} = require 'di'
class RedisConnection
	constructor: (redisP) ->
		@conn = redisP.redis().createClient config.redis.uri
		@conn.on 'ready', ->
			bragi.log(
				'application'
				bragi.util.symbols.success
				'Redis Connection established successfully'
			)

		@conn.on 'error', ->
			bragi.log(
				'application'
				bragi.util.symbols.error
				'Redis Connection could not be established'
			)

	connection: -> @conn

RedisConnection.annotations = [
	new Inject RedisProvider
]
module.exports = RedisConnection
