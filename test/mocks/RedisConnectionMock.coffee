RedisConnection = require '../../backend/connections/RedisConnection'
{annotate, Provide} = require 'di'

class RedisConnectionMock

annotate RedisConnectionMock, new Provide RedisConnection
module.exports = RedisConnectionMock