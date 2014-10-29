config = require '../config/config'
MongooseProvider = require '../providers/MongooseProvider'
{Inject} = require 'di'
class DbConnection
	constructor: (@mongooseProvider) ->
		mongoose = @mongooseProvider.mongoose
		@conn = mongoose.createConnection config.mongo.uri
		bragi.log 'application', 'Db Connection Initializing...'
		@conn.on 'open', ->
			bragi.log(
				'application'
				bragi.util.symbols.success
				'Db Connection established successfully'
			)

		@conn.on 'error', ->
			bragi.log(
				'application'
				bragi.util.symbols.error
				'Db Connection could not be established'
			)

DbConnection.annotations = [
	new Inject MongooseProvider
]
module.exports = DbConnection
