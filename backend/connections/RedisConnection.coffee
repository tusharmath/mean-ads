config = require '../config/config'
{Inject} = require 'di'
class RedisConnection
	constructor: (redisP) ->
		@conn = redisP.redis().createClient config.redis.uri
		@conn.on 'ready', ->
			bragi.log(
				'application:redis'
				bragi.util.symbols.success
				'Redis Connection established successfully'
			)

		@conn.on 'error', ->
			bragi.log(
				'application:redis'
				bragi.util.symbols.error
				'Redis Connection could not be established'
			)

RedisConnection.annotations = [
	new Inject require '../providers/RedisProvider'
]
module.exports = RedisConnection
