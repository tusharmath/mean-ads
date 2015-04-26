config = require '../config/config'
bragi = require 'bragi'
MongooseProvider = require '../providers/MongooseProvider'
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
		@_connect()
# DbConnection.annotations = [
# 	new Inject MongooseProvider
# ]
module.exports = DbConnection
