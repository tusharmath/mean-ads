config = require '../config/config'
mongoose = require('mongoose-q') require('mongoose')
class DbConnection
	constructor: ->

		@mongoose = mongoose
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

module.exports = DbConnection
