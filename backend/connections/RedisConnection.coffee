config = require '../config/config'
RedisProvider = require '../providers/RedisProvider'
{Inject} = require 'di'
class RedisConnection
	constructor: (redis) ->
		@conn = redis.createClient config.redis.uri
	connection: -> @conn

RedisConnection.annotations = [
	new Inject RedisProvider
]
module.exports = RedisConnection
