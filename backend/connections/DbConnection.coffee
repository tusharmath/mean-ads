config = require '../config/config'
logger = require 'bragi'
mongoose = require 'mongoose'
class DbConnection
	constructor: ->
		mongoose.connect config.mongo.uri
		mongoose.connection.once 'open', ->
			logger.log(
				'application'
				logger.util.symbols.success
				'Db Connection established successfully'
			)

		mongoose.connection.on 'error', ->
			logger.log(
				'application'
				logger.util.symbols.error
				'Db Connection could not be established'
			)

module.exports = DbConnection
