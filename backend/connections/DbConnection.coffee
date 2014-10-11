config = require '../config/config'
logger = require 'bragi'
mongoose = require('mongoose-q') require('mongoose')
class DbConnection
	constructor: ->

		@mongoose = mongoose
		@conn = mongoose.createConnection config.mongo.uri
		@conn.on 'open', ->
			logger.log(
				'application'
				logger.util.symbols.success
				'Db Connection established successfully'
			)

		@conn.on 'error', ->
			logger.log(
				'application'
				logger.util.symbols.error
				'Db Connection could not be established'
			)

module.exports = DbConnection
