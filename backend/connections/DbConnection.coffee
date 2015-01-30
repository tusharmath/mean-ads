config = require '../config/config'
MongooseProvider = require '../providers/MongooseProvider'
{Inject} = require 'di'
class DbConnection
	constructor: (@mongooseProvider) ->
		mongoose = @mongooseProvider.mongoose
		@_connect = =>
			@conn = mongoose.createConnection config.mongo.uri
			@conn.on 'open', ->
				bragi.log(
					'application:mongo'
					bragi.util.symbols.success
					'Db Connection established successfully'
				)

			@conn.on 'error', ->
				bragi.log(
					'application:mongo'
					bragi.util.symbols.error
					'Db Connection could not be established'
				)
			@conn.on 'disconnected', =>
				bragi.log(
					'application:mongo'
					bragi.util.symbols.error
					'Db Connection got disconnected'
				)
				setTimeout @_connect, config.mongo.options.db.autoConnectIn
		@_connect()
DbConnection.annotations = [
	new Inject MongooseProvider
]
module.exports = DbConnection
